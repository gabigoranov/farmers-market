using MarketAPI.Data.Models;
using MarketAPI.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MarketAPI.Services.Offers;
using MarketAPI.Models;
using Microsoft.EntityFrameworkCore;
using MarketAPI.Services.Users;
using MarketAPI.Services.Inventory;
using Microsoft.AspNetCore.Authorization;
using MarketAPI.Models.DTO;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for managing offers, including creation, retrieval, and deletion of offers.
    /// </summary>
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class OffersController : ControllerBase
    {
        private readonly IOffersService _offersService;
        private readonly IUsersService _usersService;
        private readonly IInventoryService _inventoryService;

        /// <summary>
        /// Initializes a new instance of the <see cref="OffersController"/> class.
        /// </summary>
        /// <param name="service">The service for managing offers.</param>
        /// <param name="usersService">The service for managing users.</param>
        /// <param name="inventoryService">The service for managing inventory.</param>
        public OffersController(IOffersService service, IUsersService usersService, IInventoryService inventoryService)
        {
            _offersService = service;
            _usersService = usersService;
            _inventoryService = inventoryService;
        }

        /// <summary>
        /// Retrieves all offers.
        /// </summary>
        /// <returns>
        /// A list of all available offers.
        /// </returns>
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_offersService.GetAll());
        }

        /// <summary>
        /// Retrieves a specific offer by its unique identifier.
        /// </summary>
        /// <param name="id">The unique identifier of the offer.</param>
        /// <returns>
        /// A single offer matching the provided identifier.
        /// </returns>
        [HttpGet("{id}")]
        public async Task<IActionResult> Single([FromRoute] int id)
        {
            OfferDTO? offer = await _offersService.GetOfferAsync(id);

            if (offer == null)
                return NotFound();

            return Ok(offer);
        }

        /// <summary>
        /// Searches for offers based on the input search string and preferred town.
        /// </summary>
        /// <param name="input">The search query input.</param>
        /// <param name="preferredTown">The town the user prefers for offers.</param>
        /// <returns>
        /// A list of offers matching the search query and town.
        /// </returns>
        [HttpGet("search")]
        public async Task<IActionResult> Search([FromQuery] string input, [FromQuery] string preferredTown)
        {
            var offers = await _offersService.SearchAsync(input, preferredTown);
            return Ok(offers);
        }

        /// <summary>
        /// Searches for offers based on a specific category and preferred town.
        /// </summary>
        /// <param name="category">The category of the offers to search for.</param>
        /// <param name="preferredTown">The preferred town for the offers.</param>
        /// <returns>
        /// A list of offers that match the specified category and town.
        /// </returns>
        [HttpGet("search-by-category")]
        public async Task<IActionResult> SearchByCategory([FromQuery] string category, [FromQuery] string preferredTown)
        {
            var offers = await _offersService.SearchWithCategoryAsync(preferredTown, category);
            return Ok(offers);
        }

        /// <summary>
        /// Creates a new offer.
        /// </summary>
        /// <param name="model">The offer details.</param>
        /// <returns>
        /// The ID of the newly created offer.
        /// </returns>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] OfferViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            SellerDTO? owner = await _usersService.GetSellerAsync(model.OwnerId);
            StockDTO? stock = await _inventoryService.GetStockAsync(model.StockId);

            if (owner == null) return NotFound("Owner with specified id does not exist.");
            if (stock == null) return NotFound("Stock with specified id does not exist.");

            int id = await _offersService.CreateOfferAsync(model);
            return Ok(id);
        }

        /// <summary>
        /// Creates a new offer type.
        /// </summary>
        /// <param name="offerType">The details of the offer type to create.</param>
        /// <returns>
        /// A success message indicating the offer type was added.
        /// </returns>
        [HttpPost("offer-type")]
        public async Task<IActionResult> CreateOfferType([FromBody] OfferType offerType)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await _offersService.CreateOfferTypeAsync(offerType);
            return Ok("Offer Added Successfully");
        }

        /// <summary>
        /// Retrieves all offer types.
        /// </summary>
        /// <returns>
        /// A list of all offer types.
        /// </returns>
        [HttpGet("offer-types")]
        public async Task<IActionResult> GetOfferTypes()
        {
            List<OfferType> res = await _offersService.GetAllOfferTypes();
            return Ok(res);
        }

        /// <summary>
        /// Edits an existing offer.
        /// </summary>
        /// <param name="id">The unique identifier of the offer to edit.</param>
        /// <param name="offer">The updated offer details.</param>
        /// <returns>
        /// A success message indicating the offer was edited.
        /// </returns>
        [HttpPut("{id}")]
        public async Task<IActionResult> Edit([FromRoute] int id, [FromBody] OfferViewModel offer)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await _offersService.EditAsync(offer);
            return Ok("Edited Successfully");
        }

        /// <summary>
        /// Deletes a specific offer by its unique identifier.
        /// </summary>
        /// <param name="id">The unique identifier of the offer to delete.</param>
        /// <returns>
        /// A success message indicating the offer was deleted.
        /// </returns>
        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOffer([FromRoute] int id)
        {
            try
            {
                await _offersService.DeleteAsync(id);
                return Ok("Deleted Successfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
