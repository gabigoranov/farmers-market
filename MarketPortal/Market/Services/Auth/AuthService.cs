using Market.Models.DTO;
using Market.Services.Authentication;
using Market.Services.Firebase;
using Microsoft.AspNetCore.Authentication.Cookies;
using Microsoft.AspNetCore.Authentication;
using Newtonsoft.Json;
using System.Security.Claims;
using Market.Data.Models;

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
        // Store user data in session (optional if you still need it)
        _httpContextAccessor.HttpContext.Session.SetString("UserData", JsonConvert.SerializeObject(user));

        // Create claims for user and role
        var claims = new List<Claim>
        {
            new Claim(ClaimTypes.UserData, JsonConvert.SerializeObject(user)),  // User data as a claim
            new Claim(ClaimTypes.Role, role)  // Role as a claim
        };

        // Optionally store cart data if needed
        if (role != "Seller")
        {
            List<FirestoreOrderDTO> cartData = await _firebaseService.GetProductById("carts", user.Id.ToString()) ?? new List<FirestoreOrderDTO>();
            _httpContextAccessor.HttpContext.Session.SetString("Cart", JsonConvert.SerializeObject(cartData));
        }

        // Create claims identity and sign in the user
        var claimsIdentity = new ClaimsIdentity(claims, CookieAuthenticationDefaults.AuthenticationScheme);
        var authProperties = new AuthenticationProperties
        {
            AllowRefresh = true,
            ExpiresUtc = DateTimeOffset.UtcNow.AddDays(7),
            IsPersistent = true,
            IssuedUtc = DateTimeOffset.UtcNow
        };

        // Sign in the user with claims
        await _httpContextAccessor.HttpContext.SignInAsync(
            CookieAuthenticationDefaults.AuthenticationScheme,
            new ClaimsPrincipal(claimsIdentity),
            authProperties);
    }

    public async Task LoadCartAsync(Guid id)
    {
        // Fetch updated cart data and store it in session
        List<FirestoreOrderDTO> cartData = await _firebaseService.GetProductById("carts", id.ToString()) ?? new List<FirestoreOrderDTO>();
        _httpContextAccessor.HttpContext.Session.SetString("Cart", JsonConvert.SerializeObject(cartData));
    }

    public async Task Logout()
    {
        // Clear session data on logout
        _httpContextAccessor.HttpContext.Session.Clear();
        await _httpContextAccessor.HttpContext.SignOutAsync();
    }

    public async Task UpdateCart(List<Order> purchase, Guid id)
    {
        // Convert List<Order> to List<FirestoreOrderDTO>
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

        // Store updated cart in session
        _httpContextAccessor.HttpContext.Session.SetString("Cart", JsonConvert.SerializeObject(firestoreOrders));

        // Update Firebase with new cart data
        await _firebaseService.SetToFirestore("carts", id.ToString(), firestoreOrders);
    }

    public async Task UpdateUserData(string userdata)
    {
        // Store updated user data in session
        _httpContextAccessor.HttpContext.Session.SetString("UserData", userdata);
    }
}
