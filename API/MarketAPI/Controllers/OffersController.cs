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
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class OffersController : ControllerBase
    {
        private readonly IOffersService _offersService;
        private readonly IUsersService _usersService;
        private readonly IInventoryService _inventoryService;
        public OffersController(IOffersService service, IUsersService usersService, IInventoryService inventoryService)
        {
            _offersService = service;
            _usersService = usersService;
            _inventoryService = inventoryService;
        }

        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_offersService.GetAll());
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Single([FromRoute] int id)
        {
            OfferDTO? offer = await _offersService.GetOfferAsync(id);

            if(offer == null)
                return NotFound();

            return Ok(offer);
        }

        [HttpGet("search")]
        public async Task<IActionResult> Search([FromQuery] string input, [FromQuery] string preferredTown)
        {
            var offers = await _offersService.SearchAsync(input, preferredTown);
            return Ok(offers);
        }

        [HttpGet("search-by-category")]
        public async Task<IActionResult> SearchByCategory([FromQuery] string category, [FromQuery] string preferredTown)
        {
            var offers = await _offersService.SearchWithCategoryAsync(preferredTown, category);
            return Ok(offers);
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] OfferViewModel model)
        {
            if(!ModelState.IsValid)
                return BadRequest(ModelState);

            SellerDTO? owner = await _usersService.GetSellerAsync(model.OwnerId);
            StockDTO? stock = await _inventoryService.GetStockAsync(model.StockId);

            if(owner == null) return NotFound("Owner with specified id does not exist.");
            if(stock == null) return NotFound("Stock with specified id does not exist.");

            int id = await _offersService.CreateOfferAsync(model);
            return Ok(id);
        }

        [HttpPost("offer-type")]
        public async Task<IActionResult> CreateOfferType([FromBody] OfferType offerType)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await _offersService.CreateOfferTypeAsync(offerType);

            return Ok("Offer Added Succesfuly");
        }

        [HttpGet("offer-types")]
        public async Task<IActionResult> GetOfferTypes()
        {
            List<OfferType> res = await _offersService.GetAllOfferTypes();
            return Ok(res);
        }

        [HttpPut("{id}")]
        public async Task<IActionResult> Edit([FromRoute] int id, [FromBody] OfferViewModel offer)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            await _offersService.EditAsync(offer); 

            return Ok("Edited Succesfully");
        }

        [HttpDelete("{id}")]
        public async Task<IActionResult> DeleteOffer([FromRoute] int id)
        {
            try
            {
                await _offersService.DeleteAsync(id);
                return Ok("Deleted Succesfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
