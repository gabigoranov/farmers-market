﻿
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

namespace Market.Services.Authentication
{
    public class AuthenticationService : IAuthenticationService
    {
        private readonly IHttpClientFactory factory;
        private readonly IHttpContextAccessor httpContextAccessor;
        private readonly HttpClient client;


        public AuthenticationService(IHttpClientFactory httpClientFactory, IHttpContextAccessor httpContextAccessor)
        {
            factory = httpClientFactory;
            client = factory.CreateClient();
            client.BaseAddress = new Uri("https://farmers-api.runasp.net/api/");
            this.httpContextAccessor = httpContextAccessor;
        }

        public async Task SignInAsync(string userdata, string role)
        {
            

            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.UserData, userdata),
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

        public async Task<string> GetAuthToken(AuthModel model)
        {
            string url = "auth/token";
            var response = await client.PostAsJsonAsync(url, model);
            string token;

            if (response.IsSuccessStatusCode)
            {
                token = await response.Content.ReadAsStringAsync();
            }
            else
            {
                throw new HttpRequestException(response.ReasonPhrase);
            }

            httpContextAccessor?.HttpContext?.Response.Cookies.Append("JWTToken", token, new CookieOptions
            {
                HttpOnly = true,
                Secure = true,  // for HTTPS
                SameSite = SameSiteMode.Strict,
                Expires = DateTime.UtcNow.AddHours(1) // Set to your token expiry time
            });

            return token;
        }
    }
}
