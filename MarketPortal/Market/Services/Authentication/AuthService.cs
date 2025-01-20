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
using Azure.Core;
using Market.Services.Firebase;
using Market.Models.DTO;
using Microsoft.AspNetCore.Http;

namespace Market.Services.Authentication
{
    public class AuthService : IAuthService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly HttpClient _client;
        private readonly IFirebaseServive _firebaseService;


        public AuthService(IHttpContextAccessor httpContextAccessor, HttpClient client, IFirebaseServive firebaseService)
        {
            _httpContextAccessor = httpContextAccessor;
            _client = client;
            _firebaseService = firebaseService;
        }

        public async Task SignInAsync(Market.Data.Models.User user, string role)
        {
            //TODO: only for organizations
            


            var claims = new List<Claim>
            {
                new Claim(ClaimTypes.UserData, JsonConvert.SerializeObject(user)),
                new Claim(ClaimTypes.Role, role),
                
            };

            if (role != "Seller")
            {
                List<FirestoreOrderDTO> cartData = await _firebaseService.GetProductById("carts", user.Id.ToString()) ?? new List<FirestoreOrderDTO>();
                claims.Add(new Claim("Cart", JsonConvert.SerializeObject(cartData)));
            }

            var claimsIdentity = new ClaimsIdentity(
                claims, CookieAuthenticationDefaults.AuthenticationScheme);

            var authProperties = new AuthenticationProperties
            {
                AllowRefresh = true,
                ExpiresUtc = DateTimeOffset.UtcNow.AddDays(7),
                IsPersistent = true,
                IssuedUtc = DateTimeOffset.UtcNow,
            };



            await _httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);
        }

        public async Task LoadCartAsync(Guid id)
        {
            List<FirestoreOrderDTO> cartData = await _firebaseService.GetProductById("carts", id.ToString()) ?? new List<FirestoreOrderDTO>();
            var currentClaims = _httpContextAccessor.HttpContext.User.Claims.ToList();

            var claimToUpdate = currentClaims.FirstOrDefault(c => c.Type == "Cart");

            if (claimToUpdate != null)
            {
                currentClaims.Remove(claimToUpdate);
                currentClaims.Add(new Claim("Cart", JsonConvert.SerializeObject(cartData)));
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



            await _httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);
        }

        public async Task Logout()
        {
            foreach (var cookie in _httpContextAccessor.HttpContext.Request.Cookies.Keys)
            {
                _httpContextAccessor.HttpContext.Response.Cookies.Delete(cookie);
            }
            _httpContextAccessor.HttpContext.Response.Clear();
            _httpContextAccessor.HttpContext.User = new ClaimsPrincipal(new ClaimsIdentity());
            await _httpContextAccessor.HttpContext.SignOutAsync();
        }

        public async Task UpdateCart(List<Order> purchase, Guid id)
        {
            // Convert the List<Order> to List<FirestoreOrderDTO>
            var firestoreOrders = purchase.Select(order => new FirestoreOrderDTO
            {
                id = order.Id,
                title = order.Title,
                isAccepted = order.IsAccepted,
                isDenied = order.IsDenied,
                quantity = order.Quantity,
                price = order.Price,
                address = order.Address,
                isDelivered = order.IsDelivered,
                offerId = order.OfferId,
                offer = new FirestoreOfferDTO()
                {
                    id = order.Offer.Id,
                    title = order.Offer.Title,
                    town = order.Offer.Town,
                    description = order.Offer.Description,
                    avgRating = order.Offer.Reviews?.Any() == true ? Math.Round(order.Offer.Reviews.Select(x => x.Rating).Average(), 2) : 0,
                    pricePerKG = order.Offer.PricePerKG,
                    ownerId = order.Offer.OwnerId.ToString(),
                    stockId = order.Offer.StockId,
                    datePosted = order.Offer.DatePosted.ToUniversalTime(),
                    discount = order.Offer.Discount,
                },
                buyerId = order.BuyerId.ToString(),
                sellerId = order.SellerId.ToString(),
                dateOrdered = order.DateOrdered.ToUniversalTime(),
                dateDelivered = order.DateDelivered?.ToUniversalTime(),
                billingDetailsId = order.BillingDetailsId


            }).ToList();


            // Use the converted List<FirestoreOrderDTO> to update Firestore
            var currentClaims = _httpContextAccessor.HttpContext.User.Claims.ToList();

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

            await _httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);

            await _firebaseService.SetToFirestore("carts", id.ToString(), firestoreOrders);
        }


        public async Task UpdateUserData(string userdata)
        {
            var currentClaims = _httpContextAccessor.HttpContext.User.Claims.ToList();

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

            await _httpContextAccessor.HttpContext.SignInAsync(
                CookieAuthenticationDefaults.AuthenticationScheme,
                new ClaimsPrincipal(claimsIdentity),
                authProperties);

        }

    }
}