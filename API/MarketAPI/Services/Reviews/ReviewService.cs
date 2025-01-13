using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Reviews
{
    public class ReviewService : IReviewService
    {
        private readonly ApiContext _context;

        public ReviewService(ApiContext context)
        {
            _context = context;
        }

        public async Task CreateReviewAsync(ReviewViewModel model)
        {
            if(!_context.Offers.Any(x => x.Id == model.OfferId)) 
                throw new ArgumentNullException(nameof(Offer), "Offer with specified id does not exist");

            Review review = new Review()
            {
                OfferId = model.OfferId,
                FirstName = model.FirstName,
                LastName = model.LastName,
                Description = model.Description,
                Rating = model.Rating,
            };

            await _context.Reviews.AddAsync(review);
            await _context.SaveChangesAsync();
        }

        public async Task DeleteReviewAsync(int id)
        {
            Review? review = await _context.Reviews.SingleOrDefaultAsync(x => x.Id == id);
            if (review == null)
                throw new ArgumentNullException(nameof(Review), "Review with specified id does not exist");

            _context.Remove(review);
            await _context.SaveChangesAsync();
        }

        public List<Review> GetOfferReviewsAsync(int id)
        {
            return _context.Reviews.Where(x => x.OfferId == id).ToList();
        }
    }
}
