using MarketAPI.Data.Models;
using MarketAPI.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MarketAPI.Models;
using MarketAPI.Services.Reviews;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewsController : ControllerBase
    {
        private readonly ApiContext _context;
        private readonly IReviewService _service;

        public ReviewsController(ApiContext context, IReviewService service)
        {
            _context = context;
            _service = service;
        }

        [HttpGet]
        [Route("get")]
        public IActionResult Get(int offerId) {
            List<Review> reviews = _context.Reviews.Where(x => x.OfferId == offerId).ToList();
            return Ok(reviews);
        }

        [HttpPost]
        [Route("add")]
        public async Task<IActionResult> Add(ReviewViewModel model)
        {
            Review review = new Review() {
                OfferId = model.OfferId,
                FirstName = model.FirstName,
                LastName = model.LastName,
                Description = model.Description,
                Rating = model.Rating,  
            };

            try
            {
                await _service.AddReviewAsync(review);
            }
            catch (Exception ex)
            {
                return BadRequest("Error: " + ex.Message);
            }
            return Ok("Review Added Succesfully");
        }

        [HttpDelete]
        [Route("delete")]
        public async Task<IActionResult> Delete(int id)
        {
            try
            {
                _context.Remove(_context.Reviews.Single(x => x.Id == id));
                await _context.SaveChangesAsync();
            }
            catch (Exception ex)
            {
                return BadRequest("Error: " + ex.Message);
            }
            return Ok("Review deleted Succesfully");
        }



    }
}
