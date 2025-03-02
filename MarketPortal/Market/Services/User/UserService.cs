using Market.Data.Models;
using Microsoft.Extensions.Caching.Memory;
using System.Net;
using System.Security.Claims;
using System.Text;
using System.Text.Json;
using System.Diagnostics;
using Market.Services.Authentication;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Microsoft.AspNetCore.Http.HttpResults;
using Azure;
using Market.Models;
using Microsoft.AspNetCore.Identity;
using Market.Data.Common.Handlers;
using Market.Services.Firebase;

namespace Market.Services
{
    public class UserService : IUserService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IAuthService _authService;
        private readonly IFirebaseServive _firebaseService;
        private readonly APIClient _client;


        private const string AUTH_BASE_URL = "https://api.freshly-groceries.com/api/auth/";
        private const string USERS_BASE_URL = "https://api.freshly-groceries.com/api/users/";

        private User? _user;

        public UserService(IHttpContextAccessor httpContextAccessor, IAuthService authService, APIClient client, IFirebaseServive firebaseService)
        {
            _user = GetUser();
            this._httpContextAccessor = httpContextAccessor;
            this._authService = authService;
            _client = client;
            _firebaseService = firebaseService;
        }




        public async Task<User> Login(AuthModel model)
        {
            var result = await _client.PostAsync<User>($"{AUTH_BASE_URL}login", model);
            if (result == null)
            {
                throw new Exception("Error with login");
            }
            _user = result;
            string role = "Seller";
            if (_user!.Discriminator == 2)
            {
                role = "Organization";

            }
            await _authService.SignInAsync(_user, role);

            return result;
        }

        public async Task<User> Refresh()
        {
            _user = GetUser();
            if (_user?.Token == null)
                throw new UnauthorizedAccessException("User token does not exist");
            var result = await _client.PostAsync<User>($"{AUTH_BASE_URL}refresh", _user.Token.RefreshToken);
            if (result == null)
            {
                throw new Exception("Error with login");
            }
            _user = result;
            string role = "Seller";
            if (_user!.Discriminator == 2)
            {
                role = "Organization";

            }
            await _authService.SignInAsync(_user, role);

            return result;
        }

        public async Task Register(UserViewModel user, int discriminator)
        {
            user.Discriminator = discriminator;
            var response = await _client.PostAsync<string>($"{AUTH_BASE_URL}register", user);
        }

        public Task RemoveOrderAsync(int orderId)
        {
            if (_user == null)
            {
                throw new Exception("User is not authenticated");
            }
            _user.SoldOrders.Remove(_user.SoldOrders.Single(x => x.Id == orderId));
            return Task.CompletedTask;

        }
        public Task DeclineOrderAsync(int orderId)
        {
            if (_user == null)
            {
                throw new Exception("User is not authenticated");
            }
            if (!_user.SoldOrders.Any(x => x.Id == orderId)) throw new Exception("Order does not exist");
            if (_user.SoldOrders == null) _user.SoldOrders = [];
            _user!.SoldOrders!.SingleOrDefault(x => x.Id == orderId)!.IsDenied = true;
            return Task.CompletedTask;
        }

        public async Task AddApprovedOrderAsync(int id)
        {
            var claim = _httpContextAccessor?.HttpContext?.User?.Claims?.SingleOrDefault(x => x.Type == ClaimTypes.UserData)?.Value;
            _user = JsonSerializer.Deserialize<User>(claim);

            _user.SoldOrders.Single(x => x.Id == id).IsAccepted = true;
            await _authService.UpdateUserData(JsonSerializer.Serialize<User>(_user));
        }

        public async Task AddDeliveredOrder(int id)
        {
            var claim = _httpContextAccessor?.HttpContext?.User?.Claims?.SingleOrDefault(x => x.Type == ClaimTypes.UserData)?.Value;
            _user = JsonSerializer.Deserialize<User>(claim);

            _user.SoldOrders.Single(x => x.Id == id).IsDelivered = true;
            await _authService.UpdateUserData(JsonSerializer.Serialize<User>(_user));

        }

        public User? GetUser()
        {
            try
            {
                if (_httpContextAccessor?.HttpContext == null)
                {
                    // Log this case, and return null as HttpContext is not available
                    return null;
                }

                var session = _httpContextAccessor.HttpContext.Session;
                if (session == null)
                {
                    // Log if session is null
                    return null;
                }

                var userJson = session.GetString("UserData");
                if (string.IsNullOrEmpty(userJson))
                    return null;

                var user = JsonSerializer.Deserialize<User>(userJson);
                _user = user;
                return user;
            }
            catch (Exception ex)
            {
                // Log the error for more insight
                return null;
            }
        }




        public async Task<List<Purchase>> GetUserBoughtPurchases()
        {
            _user = GetUser();
            if (_user == null)
            {
                throw new Exception("Error with login");
            }
            var result = await _client.GetAsync<List<Purchase>>($"{USERS_BASE_URL}history/{_user.Id}");
            return result;
        }

        public async Task<List<User>> GetAllAsync() //for development only
        {
            var contacts = new List<string>() { "db461e8d-f6b5-4b5a-9b71-08dd1adb283b", "c07bcd59-09c6-450d-6267-08dd1dfdb7cd" };
            var result = await _client.PostAsync<List<User>>($"{USERS_BASE_URL}", contacts);
            return result;
        }

        public async Task<List<ContactViewModel>> ConvertToContacts(List<User> users)
        {
            List<ContactViewModel> models = users.Select(x => new ContactViewModel()
            {
                Id = x.Id.ToString(),
                FirstName = x.FirstName ?? "Error",
                LastName = x.LastName ?? "",
                Email = x.Email,
                ProfilePictureURL = null,
                DeviceToken = x.FirebaseToken,

            }).ToList();

            foreach (ContactViewModel contact in models)
            {
                contact.ProfilePictureURL = await _firebaseService.GetImageUrl("profiles", contact.Email ?? "");
            }

            return models;
        }

        public async Task SaveReviewsAsync(List<Review> reviews)
        {
            //TODO: optimize this
            GetUser();
            foreach (Review review in reviews)
            {

                if (_user!.Offers.Single(x => x.Id == review.OfferId).Reviews == null)
                {
                    _user!.Offers.Single(x => x.Id == review.OfferId).Reviews = new List<Review>();
                }

                _user!.Offers.Single(x => x.Id == review.OfferId).Reviews.Add(review);
            }
            await _authService.UpdateUserData(JsonSerializer.Serialize(_user));
        }

        public async Task<dynamic> GetStatisticsAsync()
        {
            string url = $"https://api.freshly-groceries.com/api/Statistics/seller/{GetUser()!.Id}";
            var data = await _client.GetAsync<dynamic>(url);
            return data;
        }
    }
}