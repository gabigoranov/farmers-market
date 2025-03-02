using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Orders;
using MarketAPI.Services.Purchases;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for managing purchases, including creating new purchases and retrieving existing ones.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class PurchasesController : ControllerBase
    {
        private readonly IPurchaseService _purchaseService;

        /// <summary>
        /// Initializes a new instance of the <see cref="PurchasesController"/> class.
        /// </summary>
        /// <param name="purchaseService">The service for managing purchases.</param>
        public PurchasesController(IPurchaseService purchaseService)
        {
            _purchaseService = purchaseService;
        }

        /// <summary>
        /// Retrieves all purchases.
        /// </summary>
        /// <returns>
        /// A list of all available purchases.
        /// </returns>
        [Authorize]
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_purchaseService.GetAllPurchasesAsync());
        }

        /// <summary>
        /// Creates a new purchase.
        /// </summary>
        /// <param name="model">The purchase details.</param>
        /// <returns>
        /// A success message indicating the purchase was added successfully.
        /// </returns>
        [Authorize]
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] PurchaseViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                await _purchaseService.CreatePurchaseAsync(model);
                return Ok("Order added successfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
