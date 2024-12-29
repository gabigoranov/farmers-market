using Market.Data.Models;
using Market.Models;
using Market.Services;
using Market.Services.Authentication;
using Market.Services.Cart;
using Market.Services.Firebase;
using Market.Services.Inventory;
using Market.Services.Reviews;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Localization;
using Microsoft.AspNetCore.Mvc;
using System.Diagnostics;
using System.Security.Claims;
using System.Text.Json;

namespace Market.Controllers
{
    public class HomeController : Controller
    {
        private readonly ILogger<HomeController> _logger;
        private readonly IReviewsService _reviewsService;
        private readonly IAuthService _authService;
        private readonly IInventoryService _inventoryServive;
        private readonly IUserService _userService;
        private readonly ICartService _cartService;
        private readonly IFirebaseServive _firebaseService;
        private User _user;

        public HomeController(ILogger<HomeController> logger, IUserService userService, IAuthService authService, IInventoryService inventoryServive, IReviewsService reviewsService, ICartService cartService, IFirebaseServive firebaseService)
        {
            _logger = logger;
            _userService = userService;
            _user = _userService.GetUser();
            _authService = authService;
            _inventoryServive = inventoryServive;
            _reviewsService = reviewsService;
            _cartService = cartService;
            _firebaseService = firebaseService;
        }

        [Authorize]
        public IActionResult DownloadFile()
        { 
            return Redirect("https://drive.google.com/file/d/1wuDesdIoVtEOSpWBV3y5na3nJxreqGaQ/view?usp=drive_link");
        }

        [HttpPost]
        public IActionResult SetLanguage(string culture, string returnUrl)
        {
            Response.Cookies.Append(
                CookieRequestCultureProvider.DefaultCookieName,
                CookieRequestCultureProvider.MakeCookieValue(new RequestCulture(culture)),
                new CookieOptions { Expires = DateTimeOffset.UtcNow.AddMinutes(30) } 
            );

            return LocalRedirect(returnUrl);
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            if (_user != null)
            {
                await _authService.LoadCartAsync(_user.Id);
                if (User.IsInRole("Seller"))
                {
                    List<Stock> stocks = await _inventoryServive.GetSellerStocksAsync();
                    ViewBag.UserId = _user.Id.ToString();
                    return View(new OverviewViewModel(_user!.SoldOrders!.ToList(), _reviewsService.GetAllReviewsAsync(), stocks));
                }
                else if (User.IsInRole("Organization"))
                {
                    return RedirectToAction("Home");
                }
                
            }
            return RedirectToAction("Landing");
        }


        [HttpGet]
        public async Task<IActionResult> Home()
        {
            List<Order>? purchase = _cartService.GetPurchase();
            if (purchase == null) purchase = new List<Order>();

            List<string> urls = new List<string>();
            foreach (Order order in purchase)
            {
                urls.Add(await _firebaseService.GetImageUrl("offers", order.Offer.Id.ToString()));
            }

            ViewBag.ImageURLs = urls;
            ViewBag.UserId = _userService.GetUser().Id.ToString();
            return View();
        }

        [ResponseCache(Duration = 0, Location = ResponseCacheLocation.None, NoStore = true)]
        public IActionResult Error()
        {
            return View(new ErrorViewModel { RequestId = Activity.Current?.Id ?? HttpContext.TraceIdentifier });
        }

        [HttpGet]
        public IActionResult Help()
        {
            return View();
        }

        [HttpGet]
        public IActionResult Landing()
        {
            return View();
        }
    }
}
