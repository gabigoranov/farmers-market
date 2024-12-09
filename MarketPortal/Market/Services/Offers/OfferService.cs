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
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IUserService _userService;
        private readonly User user;
        private readonly HttpClient client;
        private readonly APIClient _apiClient;

        public OfferService(IHttpClientFactory httpClientFactory, IUserService userService, APIClient apiClient)
        {
            _httpClientFactory = httpClientFactory;
            client = _httpClientFactory.CreateClient();
            client.BaseAddress = new Uri("https://farmers-api.runasp.net/api/");
            _userService = userService;
            user = userService.GetUser();
            _apiClient = apiClient;
        }

        public async Task AddOfferAsync(Guid sellerId, OfferViewModel offer)
        {
            var jsonParsed = JsonSerializer.Serialize<OfferViewModel>(offer, new JsonSerializerOptions() { PropertyNamingPolicy = JsonNamingPolicy.CamelCase });
            var url = $"https://farmers-api.runasp.net/api/offers/";
            HttpContent content = new StringContent(jsonParsed.ToString(), Encoding.UTF8, "application/json");

            var response = await client.PostAsync(url, content);
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
            var jsonParsed = JsonSerializer.Serialize<OfferViewModel>(model, new JsonSerializerOptions() { PropertyNamingPolicy = JsonNamingPolicy.CamelCase });
            HttpContent content = new StringContent(jsonParsed.ToString(), Encoding.UTF8, "application/json");
            var response = await client.PutAsync(url, content);
        }

        public async Task<Offer> GetByIdAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/offers/{id}";
            var response = await client.GetAsync(url);
            Offer res = new Offer();
            if (response.IsSuccessStatusCode)
            {
                var stringResponse = await response.Content.ReadAsStringAsync();
                res = JsonSerializer.Deserialize<Offer>(stringResponse, new JsonSerializerOptions() { PropertyNamingPolicy = JsonNamingPolicy.CamelCase })!;
            }
            else
            {
                throw new HttpRequestException(response.ReasonPhrase);
            }
            return res;
        }

        public async Task<List<Offer>> GetDiscoverOffers()
        {
            //TODO: VALIDATION ERROR HANDLING
            string url = "https://farmers-api.runasp.net/api/offers/";
            var response = await _apiClient.GetAsync<List<Offer>>(url);
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
            var response = await _apiClient.GetAsync<List<Offer>>(url);
            return response.Where(o => o.OwnerId == sellerId).ToList();
        }

        public async Task RemoveOfferAsync(int offerId)
        {
            string url = $"https://farmers-api.runasp.net/api/offers/{offerId}";
            var response = await client.DeleteAsync(url);
        }
    }
}
