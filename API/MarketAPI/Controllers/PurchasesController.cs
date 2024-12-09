using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Orders;
using MarketAPI.Services.Purchases;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class PurchasesController : ControllerBase 
    {

        private readonly IPurchaseService _purchaseService;

        public PurchasesController(IPurchaseService purchaseService)
        {
            _purchaseService = purchaseService;
        }

        [HttpGet]
        //for testing only
        public IActionResult Get()
        {
            return Ok(_purchaseService.GetAllPurchasesAsync());
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] PurchaseViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                await _purchaseService.CreatePurchaseAsync(model);
                return Ok("Order added succesfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
           
        }
    }
}
