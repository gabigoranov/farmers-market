using Market.Data.Models;
using Market.Models;
using Market.Services;
using Market.Services.Firebase;
using Microsoft.AspNetCore.Mvc;
using System.Net;
using System.Drawing;
using System.Drawing.Imaging;
using System.IO;
using System.Text.Json;
using Market.Services.Authentication;
using Microsoft.AspNetCore.Authorization;
using Market.Services.Reviews;
using Market.Services.Inventory;
using Market.Services.Offers;
namespace Market.Controllers
{
    public class UserController : Controller
    {
        private readonly IUserService _userService;
        private readonly IAuthService _authService;
        private readonly IFirebaseServive _firebaseService;
        private readonly IReviewsService _reviewsService;
        private readonly IInventoryService _inventoryService;
        private readonly IOfferService _offerService;

        public UserController(IUserService userService, IFirebaseServive firebaseService, IAuthService authService, IReviewsService reviewsService, IInventoryService inventoryService, IOfferService offerService)
        {
            _userService = userService;
            _firebaseService = firebaseService;
            _authService = authService;
            _reviewsService = reviewsService;
            _inventoryService = inventoryService;
            _offerService = offerService;
        }

        [HttpGet]
        public IActionResult Login()
        {
            return View(new AuthModel());
        }

        [HttpPost]
        public async Task<IActionResult> Login(AuthModel model)
        {
            if (!ModelState.IsValid)
                return View(model);


            User user = await _userService.Login(model);
            if(user.Discriminator == 2)
                return RedirectToAction("Home", "Home");

            return RedirectToAction("Dashboard", "Home");
        }

        [HttpGet]
        public IActionResult Register()
        {
            return View(new AddUserViewModel() { User = new UserViewModel() { Discriminator = 1 } });
        }

        [HttpPost]
        public async Task<IActionResult> Register(AddUserViewModel model)
        {

            if (!ModelState.IsValid)
                return View(model);


            await _userService.Register(model.User, 1);
            await _firebaseService.UploadFileAsync(model.File, "profiles", model.User.Email);
            
            return RedirectToAction("Login");
        
        }

        [HttpGet]
        public IActionResult RegisterOrganization()
        {
            return View(new AddUserViewModel() { User = new UserViewModel(){ Discriminator = 2 } });
        }

        [HttpPost]
        public async Task<IActionResult> RegisterOrganization(AddOrganizationViewModel model)
        {

            if(!ModelState.IsValid)
                return View(ModelState);

            await _userService.RegisterOrganization(model.User, 2);
            await _firebaseService.UploadFileAsync(model.File, "profiles", model.User.Email);

            return RedirectToAction("Login");

        }
        
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> Profile()
        {
            if (User.IsInRole("Organization"))
                return RedirectToAction("OrganizationProfile");
            User user = _userService.GetUser();
            ProfileViewModel model = new ProfileViewModel();

            model.User = user;
            model.Orders = user.SoldOrders;
            model.Reviews = await _reviewsService.GetAllReviewsAsync();   
            model.Stocks = await _inventoryService.GetSellerStocksAsync();
            model.Offers = user.Offers;

            ViewBag.profilePicture = await _firebaseService.GetImageUrl("profiles", user.Email);
            return View(model);
        }

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> OrganizationProfile()
        {
            if (User.IsInRole("Seller"))
                return RedirectToAction("Profile");
            User user = _userService.GetUser();
            ProfileViewModel model = new ProfileViewModel();
            model.User = user;

            ViewBag.profilePicture = await _firebaseService.GetImageUrl("profiles", user.Email);
            return View(model);
        }

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> Logout()
        {
            await _authService.Logout();
            return RedirectToAction("Landing", "Home");
        }

        [HttpGet]
        [Authorize(Roles = "Seller")]
        public async Task<IActionResult> Statistics()
        {

            dynamic data = await _userService.GetStatisticsAsync();
            return Ok(data);
        }
    }
}
