using MarketAPI.Data.Models;
using MarketAPI.Services.Firebase;
using MarketAPI.Services.Orders;
using MarketAPI.Services.Token;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class StatsController : ControllerBase
    {
        private readonly IOrdersService _ordersService;

        public StatsController(IOrdersService ordersService)
        {
            _ordersService = ordersService;
        }

        [HttpGet("{id}/orders")]
        public IActionResult Orders(Guid id)
        {
            IEnumerable<Order>? orders = _ordersService.GetSellerOrders(id);
            if (orders == null)
                return NotFound("User with specified id does not exist.");
            return Ok(orders);
        }
    }
}
