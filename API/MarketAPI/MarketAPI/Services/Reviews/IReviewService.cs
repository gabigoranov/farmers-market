using MarketAPI.Data.Models;

namespace MarketAPI.Services.Reviews
{
    public interface IReviewService
    {
        public Task AddReviewAsync(Review review);
    }
}
