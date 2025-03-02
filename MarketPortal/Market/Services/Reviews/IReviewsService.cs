using Market.Data.Models;

namespace Market.Services.Reviews
{
    public interface IReviewsService
    {
        public Task AddReviewAsync(Review review);
        public Task<List<Review>> GetAllReviewsAsync();
        public List<Review> GetOfferReviewsAsync(int offerId);
        public Task RemoveReviewAsync(int id);
    }
}
