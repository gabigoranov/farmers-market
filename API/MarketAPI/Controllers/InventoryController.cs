using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Inventory;
using MarketAPI.Services.Offers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [Authorize]
    public class InventoryController : ControllerBase 
    {
        private readonly IInventoryService _inventoryService;

        public InventoryController(IInventoryService inventoryService)
        {
            _inventoryService = inventoryService;
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] StockViewModel model)
        {
            if(!ModelState.IsValid)
                return BadRequest(ModelState);

            await _inventoryService.CreateStockAsync(model);
            
            return Ok("Stock added succesfully");
        }

        [HttpGet("by-seller/{id}")]
        public IActionResult GetUserStocks([FromRoute] Guid id)
        {
            List<Stock> stocks = _inventoryService.GetUserStocksAsync(id);
            return Ok(stocks);
        }

        [HttpPost("increase/{id}")]
        public async Task<IActionResult> IncreaseQuantity([FromRoute] int id, [FromBody] double quantity)
        {
            try
            {
                await _inventoryService.IncreaseQuantityAsync(id, quantity);
                return Ok("Stock increased succesfully.");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpPost("decrease/{id}")]
        public async Task<IActionResult> DecreaseQuantity([FromRoute] int id, [FromBody] double quantity)
        {
            try
            {
                await _inventoryService.DecreaseQuantityAsync(id, quantity);
                return Ok("Stock decreased succesfully.");

            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _inventoryService.DeleteAsync(id);
            return Ok("Stock deleted succesfully.");
        }
    }
}
