using Market.Data.Common.Handlers;
using Market.Data.Models;
using Market.Models;
using System;
using System.Reflection;
using System.Text;
using System.Text.Json;

namespace Market.Services.Offers
{
    public class OfferService : IOfferService
    {
        private readonly IUserService _userService;
        private readonly User user;
        private readonly APIClient _client;

        public OfferService(IUserService userService, APIClient apiClient)
        {
            _userService = userService;
            user = userService.GetUser();
            _client = apiClient;
        }

        public async Task<int> AddOfferAsync(Guid sellerId, OfferViewModel offer)
        {
            offer.OwnerId = sellerId;
            var url = $"https://farmers-api.runasp.net/api/offers/";
            int id = await _client.PostAsync<int>(url, offer);
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
            };

            return res;
        }

        public async Task EditAsync(OfferViewModel model)
        {
            string url = "https://farmers-api.runasp.net/api/offers/";
            var response = await _client.PutAsync<string>(url, model);
        }

        public async Task<Offer> GetByIdAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/offers/{id}";
            Offer res = await _client.GetAsync<Offer>(url);
            return res;
        }

        public async Task<List<Offer>> GetDiscoverOffers()
        {
            //TODO: VALIDATION ERROR HANDLING
            string url = "https://farmers-api.runasp.net/api/offers/";
            var response = await _client.GetAsync<List<Offer>>(url);
            return response;

        }

        public async Task<OfferViewModel> GetForEditByIdAsync(int offerId)
        {
            List<Offer> offers = await GetSellerOffersAsync(user.Id);

            return ConvertOfferToViewModel(offers.Find(x => x.Id == offerId));
        }



        public async Task<List<Offer>> GetSellerOffersAsync(Guid sellerId)
        {
            string url = "https://farmers-api.runasp.net/api/offers/";
            var response = await _client.GetAsync<List<Offer>>(url);
            return response.Where(o => o.OwnerId == sellerId).ToList();
        }

        public async Task RemoveOfferAsync(int offerId)
        {
            string url = $"https://farmers-api.runasp.net/api/offers/{offerId}";
            var response = await _client.DeleteAsync<string>(url);
        }
    }
}
