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
        private const string _baseUrl = "https://api.freshly-groceries.com/api/billing/";

        public BillingService(ICartService cartService, APIClient client, IUserService userService, IAuthService authService)
        {
            _cartService = cartService;
            _client = client;
            _userService = userService;
            _authService = authService;
        }

        //Posts a new model of BillingDetails to the API
        public async Task CreateBillingDetailsAsync(BillingDetailsViewModel model)
        {
            User user = _userService.GetUser();

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

            //Posts the models and returns the id of the new billing details
            var result = await _client.PostAsync<int>(_baseUrl, billing);

            //The new id is later used when choosing a billing details for a purchase
            billing.Id = result;
            if (user.BillingDetails == null)
                user.BillingDetails = new List<BillingDetails>();
            user.BillingDetails.Add(billing);

            //Save the new _user data
            await _authService.UpdateUserData(user);
        }

        //Deletes billing details and updates _user data
        public async Task DeleteBillingDetailsAsync(int id)
        {
            User user = _userService.GetUser();
            var result = await _client.DeleteAsync<string>($"{_baseUrl}{id}");

            var billing = user?.BillingDetails?.SingleOrDefault(x => x.Id == id);
            if (billing == null)
                throw new KeyNotFoundException("Billing with specified id does not exist.");

            user?.BillingDetails?.Remove(billing);
            await _authService.UpdateUserData(user!);
        }

        //Edits billing details and saves new _user data
        public async Task EditBillingDetailsAsync(BillingDetails model)
        {
            User user = _userService.GetUser();

            var billing = user?.BillingDetails?.SingleOrDefault(x => x.Id == model.Id);
            if (billing == null)
                throw new KeyNotFoundException("Billing with specified id does not exist.");
            
            user!.BillingDetails![user.BillingDetails.IndexOf(billing)] = model;
            var result = await _client.PutAsync<string>($"{_baseUrl}{billing.Id}", billing);

            await _authService.UpdateUserData(user);
        }

        //Returns a specific entity out of the _user's collection of billing details
        public BillingDetails? GetById(int id)
        {
            User user = _userService.GetUser();
            if (user == null || user.BillingDetails == null)
                throw new NullReferenceException();
            return user!.BillingDetails!.SingleOrDefault(x => x.Id == id);
        }
    }
}