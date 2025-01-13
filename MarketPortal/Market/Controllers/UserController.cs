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
namespace Market.Controllers
{
    public class UserController : Controller
    {
        private readonly IUserService _userService;
        private readonly IAuthService _authService;
        private readonly IFirebaseServive _firebaseService;

        public UserController(IUserService userService, IFirebaseServive firebaseService, IAuthService authService)
        {
            _userService = userService;
            _firebaseService = firebaseService;
            _authService = authService;
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
                return RedirectToAction("Discover", "Offers");

            return RedirectToAction("Index", "Home");
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
            {
                return View(model);
            }

            
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
        public async Task<IActionResult> RegisterOrganization(AddUserViewModel model)
        {

            if(!ModelState.IsValid)
                return View(ModelState);

            await _userService.Register(model.User, 2);
            await _firebaseService.UploadFileAsync(model.File, "profiles", model.User.Email);

            return RedirectToAction("Login");

        }
        
        [HttpGet]
        [Authorize]
        public async Task<IActionResult> Profile()
        {
            User user = _userService.GetUser();
            ViewBag.profilePicture = await _firebaseService.GetImageUrl("profiles", user.Email);
            return View(user);
        }

        [HttpGet]
        [Authorize]
        public async Task<IActionResult> Logout()
        {
            await _authService.Logout();
            return RedirectToAction("Landing", "Home");
        }
    }
}
