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

namespace Market.Services
{
    public class UserService : IUserService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IAuthService _authService;
        private readonly APIClient _client;

        private const string AUTH_BASE_URL = "https://farmers-api.runasp.net/api/auth/";
        private const string USERS_BASE_URL = "https://farmers-api.runasp.net/api/users/";

        private User? _user;

        public UserService(IHttpContextAccessor httpContextAccessor, IAuthService authService, APIClient client)
        {
            _user = GetUser();
            this._httpContextAccessor = httpContextAccessor;
            this._authService = authService;
            _client = client;
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
                var claim = _httpContextAccessor?.HttpContext?.User?.Claims?.SingleOrDefault(x => x.Type == ClaimTypes.UserData)?.Value;
                if (claim == null) return null;
                _user = JsonSerializer.Deserialize<User>(claim);
            }
            catch (Exception ex)
            {
                return null;
            }
            return _user;
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
    }
}