using Market.Data.Common.Handlers;
using Market.Data.Models;
using Market.Models;

namespace Market.Services.Offers
{
    public class OfferService : IOfferService
    {
        private readonly IUserService _userService;
        private readonly User user;
        private readonly APIClient _client;
        private const string BASE_URL = "https://api.freshly-groceries.com/api/offers/";

        public OfferService(IUserService userService, APIClient apiClient)
        {
            _userService = userService;
            user = userService.GetUser();
            _client = apiClient;
        }

        public async Task<int> AddOfferAsync(Guid sellerId, OfferViewModel offer)
        {
            offer.OwnerId = sellerId;
            int id = await _client.PostAsync<int>(BASE_URL, offer);
            return id;
        }

        public OfferViewModel ConvertOfferToViewModel(Offer offer)
        {
            OfferViewModel res = new OfferViewModel()
            {
                Id = offer.Id,
                Title = offer.Title,
                Town = offer.Town,
                Description = offer.Description,
                PricePerKG = offer.PricePerKG,
                StockId = offer.StockId,
                OwnerId = offer.OwnerId,
                Discount = offer.Discount,
            };

            return res;
        }

        public async Task EditAsync(OfferViewModel model)
        {
            var response = await _client.PutAsync<string>($"{BASE_URL}{model.Id}", model);
        }

        public async Task<Offer> GetByIdAsync(int id)
        {
            Offer res = await _client.GetAsync<Offer>($"{BASE_URL}{id}");
            return res;
        }

        public async Task<List<Offer>> GetDiscoverOffers()
        {
            //TODO: VALIDATION ERROR HANDLING
            var response = await _client.GetAsync<List<Offer>>(BASE_URL);
            return response;

        }

        public async Task<OfferViewModel> GetForEditByIdAsync(int offerId)
        {
            Offer offer = await GetByIdAsync(offerId);

            return ConvertOfferToViewModel(offer);
        }



        public async Task<List<Offer>> GetSellerOffersAsync(Guid sellerId)
        {
            var response = await _client.GetAsync<List<Offer>>(BASE_URL);
            return response.Where(o => o.OwnerId == sellerId).ToList();
        }

        public async Task RemoveOfferAsync(int offerId)
        {
            var response = await _client.DeleteAsync<string>($"{BASE_URL}{offerId}");
        }

        public async Task<List<OfferType>> GetOfferTypes()
        {
            List<OfferType> response = await _client.GetAsync<List<OfferType>>($"{BASE_URL}offer-types");
            return response;
        }

        public async Task<List<Review>> GetOfferReviewsAsync(int offerId)
        {
            List<Review> res = await _client.GetAsync<List<Review>>($"https://api.freshly-groceries.com/api/reviews/by-offer/{offerId}");
            return res;
        }
    }
}
