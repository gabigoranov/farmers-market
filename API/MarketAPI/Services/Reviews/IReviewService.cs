using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Reviews
{
    public interface IReviewService
    {
        public Task CreateReviewAsync(ReviewViewModel model);
        public Task DeleteReviewAsync(int id);
        public List<ReviewDTO> GetOfferReviewsAsync(int id);
        Task<List<ReviewDTO>> GetSellerOffersAsync(Guid id);
    }
}
