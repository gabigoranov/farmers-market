using MarketAPI.Data.Models;
using MarketAPI.Data;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using MarketAPI.Services.Offers;
using MarketAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class OffersController : ControllerBase
    {
        private readonly IOffersService _service;
        private readonly ApiContext _context;
        public OffersController(IOffersService service, ApiContext _context)
        {
            _service = service;
            this._context = _context;
        }

        [HttpGet]
        [Route("getAll")]
        public async Task<IActionResult> GetAll()
        {
            List<Offer> products = await _service.GetAllAsync();

            return Ok(products);
        }

        [HttpGet]
        [Route("single")]
        public async Task<IActionResult> Single(int id)
        {
            Offer? offer = await _service.SingleAsync(id);
            if(offer == null)
            {
                return NotFound("Offer does not exist");
            }
            return Ok(offer);
        }

        [HttpGet]
        [Route("search")]
        public async Task<IActionResult> Search(string input, string prefferedTown)
        {
            List<Offer> products = await _service.SearchAsync(input, prefferedTown);


            return Ok(products);
        }

        [HttpGet]
        [Route("categorySearch")]
        public async Task<IActionResult> CategorySearch(string prefferedTown, string category)
        {
            List<Offer> products = await _service.SearchWithCategoryAsync(prefferedTown, category);


            return Ok(products);
        }

        [HttpPost]
        [Route("add")]
        public async Task<IActionResult> Add(OfferViewModel offer)
        {
            await _service.AddOffer(new Offer()
            {
                Title = offer.Title,
                Description = offer.Description,
                PricePerKG = offer.PricePerKG,
                StockId = offer.StockId,
                OwnerId = offer.OwnerId,
                Town = offer.Town,
                Owner = await _context.Sellers.FirstAsync(x => x.Id == offer.OwnerId),
                Stock = await _context.Stocks.FirstAsync(x => x.Id == offer.StockId),
                DatePosted = DateTime.Now,
                Discount = offer.Discount,
            });
            return Ok("Offer Added Succesfuly");
        }

        [HttpPost]
        [Route("addOfferType")]
        public async Task<IActionResult> AddOfferType(OfferType offerType)
        {
            await _context.OfferTypes.AddAsync(offerType);
            await _context.SaveChangesAsync();
            return Ok("Offer Added Succesfuly");
        }

        [HttpPost]
        [Route("edit")]
        public async Task<IActionResult> EditOffer(OfferViewModel offer)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest(offer);
            }

            await _service.EditAsync(offer);

            return Ok("Edited Succesfully");
        }

        [HttpDelete]
        [Route("delete")]
        public async Task<IActionResult> DeleteOffer(int id)
        {
            var offers = await _service.GetAllAsync();

            if (!offers.Any(x => x.Id == id)) return BadRequest("Invalid Id");
            var offer = await _service.GetByIdAsync(id);

            await _service.RemoveByIdAsync(id);

            return Ok("Deleted Succesfully");
        }
    }
}
