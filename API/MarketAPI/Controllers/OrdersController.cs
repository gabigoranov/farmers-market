using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Firebase;
using MarketAPI.Services.Orders;
using MarketAPI.Services.Token;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.Identity.Client;
using Microsoft.IdentityModel.Abstractions;
using System.Diagnostics;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for managing orders, including creating, approving, declining, and delivering orders.
    /// </summary>
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class OrdersController : ControllerBase
    {
        private readonly IOrdersService _ordersService;
        private readonly TokenService _tokenService;
        private readonly FirebaseService _firebaseService;

        /// <summary>
        /// Initializes a new instance of the <see cref="OrdersController"/> class.
        /// </summary>
        /// <param name="ordersService">The service for managing orders.</param>
        /// <param name="firebaseService">The service for interacting with Firebase notifications.</param>
        /// <param name="tokenService">The service for managing tokens.</param>
        public OrdersController(IOrdersService ordersService, FirebaseService firebaseService, TokenService tokenService)
        {
            _ordersService = ordersService;
            _firebaseService = firebaseService;
            _tokenService = tokenService;
        }

        /// <summary>
        /// Retrieves all orders.
        /// </summary>
        /// <returns>
        /// A list of all available orders.
        /// </returns>
        [HttpGet]
        // For testing only
        public IActionResult Get()
        {
            return Ok(_ordersService.GetAllOrders());
        }

        /// <summary>
        /// Retrieves a specific order by its unique identifier.
        /// </summary>
        /// <param name="id">The unique identifier of the order.</param>
        /// <returns>
        /// A single order matching the provided identifier.
        /// </returns>
        [HttpGet("{id}")]
        public async Task<IActionResult> GetOrder([FromRoute] int id)
        {
            OrderDTO? order = await _ordersService.GetOrderAsync(id);

            if (order == null)
                return BadRequest("Order with specified id does not exist.");
            return Ok(order);
        }

        /// <summary>
        /// Creates a new order.
        /// </summary>
        /// <param name="model">The order details.</param>
        /// <returns>
        /// A success message indicating the order was added successfully.
        /// </returns>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] RequiredOrderViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            await _ordersService.CreateOrderAsync(model, model.BillingDetailsId);
            return Ok("Order added successfully");
        }

        /// <summary>
        /// Approves an order, which decreases the stock and notifies the user.
        /// </summary>
        /// <param name="id">The unique identifier of the order to approve.</param>
        /// <returns>
        /// A success message indicating the order was approved.
        /// </returns>
        [HttpPut("{id}/approve")]
        public async Task<IActionResult> Approve([FromRoute] int id)
        {
            try
            {
                string? userFirebaseToken = await _ordersService.ApproveOrderAsync(id);
                await _firebaseService.SendNotification(userFirebaseToken, "Order Accepted", "You can expect a delivery.", id, "accepted");
                return Ok("Approved purchase successfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Declines an order and notifies the user.
        /// </summary>
        /// <param name="id">The unique identifier of the order to decline.</param>
        /// <returns>
        /// A success message indicating the order was declined.
        /// </returns>
        [HttpPut("{id}/decline")]
        public async Task<IActionResult> Decline([FromRoute] int id)
        {
            try
            {
                string? userFirebaseToken = await _ordersService.DeclineOrderAsync(id);
                await _firebaseService.SendNotification(userFirebaseToken, "Order Declined", "One of your orders has been declined.", id, "declined");
                return Ok("Declined purchase successfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Marks an order as delivered and notifies the user.
        /// </summary>
        /// <param name="id">The unique identifier of the order to mark as delivered.</param>
        /// <returns>
        /// A success message indicating the order was delivered.
        /// </returns>
        [HttpPut("{id}/deliver")]
        public async Task<IActionResult> Deliver([FromRoute] int id)
        {
            try
            {
                string? userFirebaseToken = await _ordersService.DeliverOrderAsync(id);
                await _firebaseService.SendNotification(userFirebaseToken, "Order Delivered", "Your order has been successfully delivered!", id, "delivered");
                return Ok("Purchase delivered successfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
