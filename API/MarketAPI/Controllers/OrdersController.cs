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
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class OrdersController : ControllerBase
    {

        private readonly IOrdersService _ordersService;
        private readonly TokenService _tokenService;
        private readonly FirebaseService _firebaseService;

        public OrdersController(IOrdersService ordersService, FirebaseService firebaseService, TokenService tokenService)
        {
            _ordersService = ordersService;
            _firebaseService = firebaseService;
            _tokenService = tokenService;
        }

        [HttpGet]
        //for testing only
        public IActionResult Get()
        {
            return Ok(_ordersService.GetAllOrders());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> GetOrder([FromRoute] int id)
        {
            

            OrderDTO? order = await _ordersService.GetOrderAsync(id);

            if (order == null)
                return BadRequest("Order with specified id does not exist.");
            return Ok(order);
        }


        [HttpPost]
        public async Task<IActionResult> Create([FromBody] RequiredOrderViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            await _ordersService.CreateOrderAsync(model, model.BillingDetailsId);
            return Ok("Order added successfully");
        }

        [HttpPut("{id}/approve")]
        //seller accepts order and stock is decreased
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

        [HttpPut("{id}/decline")]
        public async Task<IActionResult> Decline([FromRoute] int id)
        {
            try
            {
                string? userFirebaseToken = await _ordersService.DeclineOrderAsync(id);
                await _firebaseService.SendNotification(userFirebaseToken, "Order Declined", "One of your orders has been devlined.", id, "declined");
                return Ok("Declined purchase successfully");

            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpPut("{id}/deliver")]
        public async Task<IActionResult> Deliver([FromRoute] int id)
        {
            try
            {
                string? userFirebaseToken = await _ordersService.DeliverOrderAsync(id);
                await _firebaseService.SendNotification(userFirebaseToken, "Order Delivered", "Your order has been successfully delivered!", id, "delivered");
                return Ok("Purchase delivered succesfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}