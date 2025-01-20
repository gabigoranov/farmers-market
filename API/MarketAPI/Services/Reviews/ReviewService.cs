using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Reviews
{
    public class ReviewService : IReviewService
    {
        private readonly ApiContext _context;
        private readonly IMapper _mapper;


        public ReviewService(ApiContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task CreateReviewAsync(ReviewViewModel model)
        {
            if(!_context.Offers.Any(x => x.Id == model.OfferId)) 
                throw new ArgumentNullException(nameof(Offer), "Offer with specified id does not exist");

            Review review = _mapper.Map<Review>(model);

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

        public List<ReviewDTO> GetOfferReviewsAsync(int id)
        {
            var res = _context.Reviews.Where(x => x.OfferId == id).ToList();
            return _mapper.Map<List<ReviewDTO>>(res);  
        }

        public async Task<List<ReviewDTO>> GetSellerOffersAsync(Guid id)
        {
            var res = await _context.Reviews.Where(x => x.Offer.OwnerId == id).ToListAsync();
            return _mapper.Map<List<ReviewDTO>>(res);
        }
    }
}
