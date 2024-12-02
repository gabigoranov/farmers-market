using MarketAPI.Data;
using MarketAPI.Data.Models;

namespace MarketAPI.Services.Reviews
{
    public class ReviewService : IReviewService
    {
        private readonly ApiContext _context;

        public ReviewService(ApiContext context)
        {
            _context = context;
        }


        public async Task AddReviewAsync(Review review)
        {
            await _context.Reviews.AddAsync(review);
            await _context.SaveChangesAsync();
        }
    }
}
