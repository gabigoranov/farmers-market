using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Inventory;
using MarketAPI.Services.Offers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for managing inventory, including creating, updating, and deleting stock.
    /// </summary>
    [Route("api/[controller]")]
    [Authorize]
    public class InventoryController : ControllerBase
    {
        private readonly IInventoryService _inventoryService;

        /// <summary>
        /// Initializes a new instance of the <see cref="InventoryController"/> class.
        /// </summary>
        /// <param name="inventoryService">Service for managing inventory operations.</param>
        public InventoryController(IInventoryService inventoryService)
        {
            _inventoryService = inventoryService;
        }

        /// <summary>
        /// Creates new stock in the inventory.
        /// </summary>
        /// <param name="model">The stock details to create.</param>
        /// <returns>
        /// A response indicating whether the operation was successful.
        /// </returns>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] StockViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await _inventoryService.CreateStockAsync(model);
            return Ok("Stock added successfully");
        }

        /// <summary>
        /// Retrieves all stocks for a specific seller.
        /// </summary>
        /// <param name="id">The unique identifier of the seller.</param>
        /// <returns>
        /// A list of stock items associated with the seller.
        /// </returns>
        [HttpGet("by-seller/{id}")]
        public IActionResult GetUserStocks([FromRoute] Guid id)
        {
            List<StockDTO> stocks = _inventoryService.GetUserStocksAsync(id);
            return Ok(stocks);
        }

        /// <summary>
        /// Increases the quantity of stock for a specific item.
        /// </summary>
        /// <param name="id">The unique identifier of the stock item.</param>
        /// <param name="quantity">The amount to increase the stock by.</param>
        /// <returns>
        /// A response indicating whether the operation was successful.
        /// </returns>
        [HttpPost("increase/{id}")]
        public async Task<IActionResult> IncreaseQuantity([FromRoute] int id, [FromBody] double quantity)
        {
            try
            {
                await _inventoryService.IncreaseQuantityAsync(id, quantity);
                return Ok("Stock increased successfully.");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Decreases the quantity of stock for a specific item.
        /// </summary>
        /// <param name="id">The unique identifier of the stock item.</param>
        /// <param name="quantity">The amount to decrease the stock by.</param>
        /// <returns>
        /// A response indicating whether the operation was successful.
        /// </returns>
        [HttpPost("decrease/{id}")]
        public async Task<IActionResult> DecreaseQuantity([FromRoute] int id, [FromBody] double quantity)
        {
            try
            {
                await _inventoryService.DecreaseQuantityAsync(id, quantity);
                return Ok("Stock decreased successfully.");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Deletes a specific stock item from the inventory.
        /// </summary>
        /// <param name="id">The unique identifier of the stock item to delete.</param>
        /// <returns>
        /// A response indicating whether the operation was successful.
        /// </returns>
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(int id)
        {
            await _inventoryService.DeleteAsync(id);
            return Ok("Stock deleted successfully.");
        }
    }
}
