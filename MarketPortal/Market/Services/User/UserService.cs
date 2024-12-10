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

        private User? User;

        public UserService(IHttpContextAccessor httpContextAccessor, IAuthService authService, APIClient client)
        {
            User = GetUser();
            this._httpContextAccessor = httpContextAccessor;
            this._authService = authService;
            _client = client;
        }




        public async Task<User> Login(AuthModel model)
        {
            var url = $"https://farmers-api.runasp.net/api/auth/login/";
            var result = await _client.PostAsync<User>(url, model);
            User = result;
            if(result ==  null)
            { 
                throw new Exception("Error with login");
            }
            return result;
        }

        public async Task Register(UserViewModel user)
        {
            var url = $"https://farmers-api.runasp.net/api/auth/register/";
            var response = await _client.PostAsync<string>(url, user);
        }

        public Task RemoveOrderAsync(int orderId)
        {
            if (User == null)
            {
                throw new Exception("User is not authenticated");
            }
            User.SoldOrders.Remove(User.SoldOrders.Single(x => x.Id == orderId));
            return Task.CompletedTask;

        }
        public Task DeclineOrderAsync(int orderId)
        {
            if(User == null)
            {
                throw new Exception("User is not authenticated");
            }
            if (!User.SoldOrders.Any(x => x.Id == orderId)) throw new Exception("Order does not exist");
            if (User.SoldOrders == null) User.SoldOrders = [];
            User!.SoldOrders!.SingleOrDefault(x => x.Id == orderId)!.IsDenied = true;
            return Task.CompletedTask;
        }

        public async Task AddApprovedOrderAsync(int id)
        {
            var claim = _httpContextAccessor?.HttpContext?.User?.Claims?.SingleOrDefault(x => x.Type == ClaimTypes.UserData)?.Value;
            User = JsonSerializer.Deserialize<User>(claim);

            User.SoldOrders.Single(x => x.Id == id).IsAccepted = true;
            await _authService.UpdateUserData(JsonSerializer.Serialize<User>(User));
        }

        public async Task AddDeliveredOrder(int id)
        {
            var claim = _httpContextAccessor?.HttpContext?.User?.Claims?.SingleOrDefault(x => x.Type == ClaimTypes.UserData)?.Value;
            User = JsonSerializer.Deserialize<User>(claim);
            
            User.SoldOrders.Single(x => x.Id == id).IsDelivered = true;
            await _authService.UpdateUserData(JsonSerializer.Serialize<User>(User));

        }

        public User? GetUser()
        {
            try
            {
                var claim = _httpContextAccessor?.HttpContext?.User?.Claims?.SingleOrDefault(x => x.Type == ClaimTypes.UserData)?.Value;
                if (claim == null) return null;
                User = JsonSerializer.Deserialize<User>(claim);
            }
            catch(Exception ex)
            {
                return null;
            }
            return User;
        }

        public async Task<List<Purchase>> GetUserBoughtPurchases()
        {
            User = GetUser();
            if (User == null)
            {
                throw new Exception("Error with login");
            }
            string url = $"https://farmers-api.runasp.net/api/users/history/{User.Id}";
            var result = await _client.GetAsync<List<Purchase>>(url);
            return result;
        }
    }
}
