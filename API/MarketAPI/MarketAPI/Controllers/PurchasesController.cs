using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Orders;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchasesController : ControllerBase
    {

        private readonly IOrdersService _ordersService;
        private readonly ApiContext _context;

        public PurchasesController(IOrdersService ordersService, ApiContext context)
        {
            _ordersService = ordersService;
            _context = context;
        }

        [HttpGet]
        [Route("getall")]
        //for testing only
        public async Task<IActionResult> GetAll()
        {
            List<Purchase> orders = await _context.Purchases.Include(x => x.Orders).ToListAsync();
            return Ok(orders);
        }

        [HttpPost]
        [Route("add")]
        public async Task<IActionResult> AddPurchase(PurchaseViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("ModelState is invalid");
            }

            Purchase purchase = new Purchase()
            {
                Address = model.Address,
                IsApproved = false,
                DateOrdered = DateTime.UtcNow,
                BuyerId = model.BuyerId,
                Orders = await _ordersService.AddOrdersAsync(model.Orders),
                Price = model.Price,
            };

            await _context.Purchases.AddAsync(purchase);
            await _context.SaveChangesAsync();

            return Ok("Order added succesfully");
        }

        [HttpGet]
        [Route("accept")]
        //seller accepts order and stock is decreased
        public async Task<IActionResult> Accept(int id)
        {
            Purchase purchase = _context.Purchases.Include(x => x.Orders).First(x => x.Id == id);
            _context.Update(purchase);
            _context.Update(purchase.Orders);
            purchase.IsApproved = true;
            
            foreach(var order in purchase.Orders)
            {
                _context.Stocks.Single(x => x.Id == order.Offer.StockId).Quantity -= order.Quantity;
            }

            await _context.SaveChangesAsync();
            return Ok("Approved purchase succesfully");
        }

        [HttpGet]
        [Route("decline")]
        public async Task<IActionResult> Decline(int id)
        {
            Purchase purchase = _context.Purchases.First(x => x.Id == id);
            _context.Purchases.Remove(purchase);
            await _context.SaveChangesAsync();
            return Ok("Declined purchase successfully");
        }

        [HttpGet]
        [Route("deliver")]
        public async Task<IActionResult> Deliver(int id)
        {
            Purchase purchase = _context.Purchases.Single(x => x.Id == id);
            _context.Update(purchase);
            purchase.IsDelivered = true;   
            purchase.DateDelivered = DateTime.Now;
            await _context.SaveChangesAsync();
            return Ok("Purchase delivered succesfully");
        }

    }
}
