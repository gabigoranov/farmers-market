using Market.Models;
using Market.Services;
using Market.Services.Advertise;
using Market.Services.Offers;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Market.Controllers
{
    [Authorize(Roles = "Seller")]
    public class AdvertiseController : Controller
    {
        private readonly IOfferService _offerService;
        private readonly IUserService _userService;
        private readonly IAdvertiseService _advertiseService;

        public AdvertiseController(IOfferService offerService, IUserService userService, IAdvertiseService advertiseService)
        {
            _offerService = offerService;
            _userService = userService;
            _advertiseService = advertiseService;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            var model = new AddAdvertiseSettingsViewModel();
            model.AvailableOffers = await _offerService.GetSellerOffersAsync(_userService.GetUser().Id);
            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> Create(AddAdvertiseSettingsViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return View(model);
            }

            await _advertiseService.Create(model);

            return RedirectToAction("Dashboard", "Home");
        }
    }
}
