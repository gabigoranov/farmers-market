using Market.Data.Common.Handlers;
using Market.Data.Models;
using Market.Models;
using Market.Services.Authentication;
using Market.Services.Cart;
using Newtonsoft.Json;

namespace Market.Services.Billing
{
    public class BillingService : IBillingService
    {

        private readonly ICartService _cartService;
        private readonly IUserService _userService;
        private readonly IAuthService _authService;
        private readonly APIClient _client;


        public BillingService(ICartService cartService, APIClient client, IUserService userService, IAuthService authService)
        {
            _cartService = cartService;
            _client = client;
            _userService = userService;
            _authService = authService;
        }

        public async Task CreateBillingDetailsAsync(BillingDetailsViewModel model)
        {
            User user = _userService.GetUser();

            string url = "https://farmers-api.runasp.net/api/billing";
            BillingDetails billing = new BillingDetails()
            {
                Id = 0,
                Address = model.Address,
                City = model.City,
                Email = model.Email,
                FullName = model.FullName,
                Orders = [],
                PhoneNumber = model.PhoneNumber,
                PostalCode = model.PostalCode,
                Purchases = [],
                UserId = user.Id
            };

            var result = await _client.PostAsync<int>(url, billing);
            billing.Id = result;
            if (user.BillingDetails == null)
                user.BillingDetails = new List<BillingDetails>();
            user.BillingDetails.Add(billing);
            await _authService.UpdateUserData(JsonConvert.SerializeObject(user));
        }

        public async Task DeleteBillingDetailsAsync(int id)
        {
            User user = _userService.GetUser();

            string url = $"https://farmers-api.runasp.net/api/billing/{id}";
            var result = await _client.DeleteAsync<string>(url);
            var billing = user?.BillingDetails?.SingleOrDefault(x => x.Id == id);
            if (billing == null)
                throw new KeyNotFoundException("Billing with specified id does not exist.");
            user?.BillingDetails?.Remove(billing);
            await _authService.UpdateUserData(JsonConvert.SerializeObject(user));
        }

        public async Task EditBillingDetailsAsync(BillingDetails model)
        {
            User user = _userService.GetUser();

            var billing = user?.BillingDetails?.SingleOrDefault(x => x.Id == model.Id);
            if (billing == null)
                throw new KeyNotFoundException("Billing with specified id does not exist.");
            user!.BillingDetails![user.BillingDetails.IndexOf(billing)] = model;
            string url = $"https://farmers-api.runasp.net/api/billing/{billing.Id}";
            var result = await _client.PutAsync<string>(url, billing);
            
            await _authService.UpdateUserData(JsonConvert.SerializeObject(user));
        }

        public BillingDetails? GetById(int id)
        {
            User user = _userService.GetUser();
            if (user == null || user.BillingDetails == null)
                throw new NullReferenceException();
            return user!.BillingDetails!.SingleOrDefault(x => x.Id == id);
        }
    }
}
