using MarketAPI.Data.Models;
using MarketAPI.Models;

namespace MarketAPI.Services.Reviews
{
    public interface IReviewService
    {
        public Task CreateReviewAsync(ReviewViewModel model);
        public Task DeleteReviewAsync(int id);
        public List<Review> GetOfferReviewsAsync(int id);
    }
}
