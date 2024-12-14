
using Firebase.Auth;
using Market.Data.Models;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using System.Security.Claims;
using Newtonsoft.Json;
using Market.Models;
using Azure;
using Newtonsoft.Json.Linq;
using System.Text.Json;
using NuGet.Protocol;
using Market.Data.Common.Handlers;

namespace Market.Services.Authentication
{
    public class AuthService : IAuthService
    {
        private readonly IHttpContextAccessor httpContextAccessor;
        private readonly HttpClient client;


        public AuthService(IHttpContextAccessor httpContextAccessor, HttpClient client)
        {
            this.httpContextAccessor = httpContextAccessor;
            this.client = client;
        }

        public async Task SignInAsync(Market.Data.Models.User user, string role)
        {

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.UserData, JsonConvert.SerializeObject(user)),
                new Claim(ClaimTypes.Role, role),
                new Claim("Cart", JsonConvert.SerializeObject(new Purchase())),
            };

            var claimsIdentity = new ClaimsIdentity(
                claims, CookieAuthenticationDefaults.AuthenticationScheme);

            var authProperties = new AuthenticationProperties
            {
                AllowRefresh = true,
                ExpiresUtc = DateTimeOffset.UtcNow.AddDays(7),
                IsPersistent = true,
                IssuedUtc = DateTimeOffset.UtcNow,
            };

            

            await httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);
        }

        public async Task Logout()
        {
            await httpContextAccessor.HttpContext.SignOutAsync();
            httpContextAccessor.HttpContext.Response.Clear();
        }

        public async Task UpdateCart(Purchase purchase)
        {
            var currentClaims = httpContextAccessor.HttpContext.User.Claims.ToList();

            var claimToUpdate = currentClaims.FirstOrDefault(c => c.Type == "Cart");

            if (claimToUpdate != null)
            {
                currentClaims.Remove(claimToUpdate);
                currentClaims.Add(new Claim("Cart", JsonConvert.SerializeObject(purchase)));
            }

            var claimsIdentity = new ClaimsIdentity(
                currentClaims, CookieAuthenticationDefaults.AuthenticationScheme);

            var authProperties = new AuthenticationProperties
            {
                AllowRefresh = true,
                ExpiresUtc = DateTimeOffset.UtcNow.AddDays(7),
                IsPersistent = true,
                IssuedUtc = DateTimeOffset.UtcNow,
            };

            await httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);

        }

        public async Task UpdateUserData(string userdata)
        {
            var currentClaims = httpContextAccessor.HttpContext.User.Claims.ToList();

            var claimToUpdate = currentClaims.FirstOrDefault(c => c.Type == ClaimTypes.UserData);

            if (claimToUpdate != null)
            {
                currentClaims.Remove(claimToUpdate);
                currentClaims.Add(new Claim(ClaimTypes.UserData, userdata));
            }

            var claimsIdentity = new ClaimsIdentity(
                currentClaims, CookieAuthenticationDefaults.AuthenticationScheme);

            var authProperties = new AuthenticationProperties
            {
                AllowRefresh = true,
                ExpiresUtc = DateTimeOffset.UtcNow.AddDays(7),
                IsPersistent = true,
                IssuedUtc = DateTimeOffset.UtcNow,
            };

            await httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);

        }

    }
}
