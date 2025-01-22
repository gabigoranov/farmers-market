using MarketAPI.Data.Models;
using MarketAPI.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MarketAPI.Models;
using MarketAPI.Services.Reviews;
using Microsoft.AspNetCore.Authorization;
using MarketAPI.Models.DTO;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for managing reviews, including creating, deleting, and retrieving reviews for offers and sellers.
    /// </summary>
    [Route("api/[controller]")]
    [Authorize]
    [ApiController]
    public class ReviewsController : ControllerBase
    {
        private readonly ApiContext _context;
        private readonly IReviewService _reviewsService;

        /// <summary>
        /// Initializes a new instance of the <see cref="ReviewsController"/> class.
        /// </summary>
        /// <param name="context">The database context.</param>
        /// <param name="service">The review service for handling review-related operations.</param>
        public ReviewsController(ApiContext context, IReviewService service)
        {
            _context = context;
            _reviewsService = service;
        }

        /// <summary>
        /// Retrieves reviews for a specific offer.
        /// </summary>
        /// <param name="id">The ID of the offer.</param>
        /// <returns>
        /// A list of reviews for the specified offer.
        /// </returns>
        [HttpGet("by-offer/{id}")]
        public IActionResult Get([FromRoute] int id)
        {
            return Ok(_reviewsService.GetOfferReviewsAsync(id));
        }

        /// <summary>
        /// Retrieves reviews for a specific seller.
        /// </summary>
        /// <param name="id">The ID of the seller.</param>
        /// <returns>
        /// A list of reviews for the specified seller.
        /// </returns>
        [HttpGet("by-seller/{id}")]
        public async Task<IActionResult> Get([FromRoute] Guid id)
        {
            List<ReviewDTO> reviews = await _reviewsService.GetSellerOffersAsync(id);
            return Ok(reviews);
        }

        /// <summary>
        /// Creates a new review.
        /// </summary>
        /// <param name="model">The review details.</param>
        /// <returns>
        /// A success message indicating the review was added successfully.
        /// </returns>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] ReviewViewModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            try
            {
                await _reviewsService.CreateReviewAsync(model);
                return Ok("Review Added Successfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Deletes a specific review.
        /// </summary>
        /// <param name="id">The ID of the review to delete.</param>
        /// <returns>
        /// A success message indicating the review was deleted successfully.
        /// </returns>
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            try
            {
                await _reviewsService.DeleteReviewAsync(id);
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }

            return Ok("Review deleted Successfully");
        }
    }
}
