using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Firebase;
using MarketAPI.Services.Orders;
using MarketAPI.Services.Token;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for fetching statistics related to orders for a seller.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class StatsController : ControllerBase
    {
        private readonly IOrdersService _ordersService;

        /// <summary>
        /// Initializes a new instance of the <see cref="StatsController"/> class.
        /// </summary>
        /// <param name="ordersService">The service used for managing orders and retrieving order data.</param>
        public StatsController(IOrdersService ordersService)
        {
            _ordersService = ordersService;
        }

        /// <summary>
        /// Retrieves the orders for a specific seller.
        /// </summary>
        /// <param name="id">The ID of the seller.</param>
        /// <returns>
        /// A list of orders placed by the seller, or a not found message if the seller does not exist.
        /// </returns>
        [HttpGet("{id}/orders")]
        public IActionResult Orders(Guid id)
        {
            IEnumerable<OrderDTO>? orders = _ordersService.GetSellerOrders(id);
            if (orders == null)
                return NotFound("User with specified id does not exist.");
            return Ok(orders);
        }
    }
}
