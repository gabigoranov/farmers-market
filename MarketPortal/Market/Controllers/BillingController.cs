using Market.Models;
using Market.Services.Cart;
using Market.Services.Firebase;
using Market.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Market.Services.Billing;
using Market.Data.Models;

namespace Market.Controllers
{
    [Authorize(Roles = "Organization")]
    public class BillingController : Controller
    {
        private readonly ICartService _cartService;
        private readonly IBillingService _billingService;
        private readonly IFirebaseServive _firebaseService;
        private readonly IUserService _userService;
        public BillingController(ICartService cartService, IUserService userService, IFirebaseServive firebaseService, IBillingService billingService)
        {
            _cartService = cartService;
            _userService = userService;
            _firebaseService = firebaseService;
            _billingService = billingService;
        }

        [HttpGet]
        public IActionResult Add()
        {
            BillingDetailsViewModel model = new BillingDetailsViewModel();
            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> Add(BillingDetailsViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);
            await _billingService.CreateBillingDetailsAsync(model);
            return RedirectToAction("Index", "Cart");
        }

        [HttpGet]
        public IActionResult Edit(int id)
        {
            BillingDetails? model = _billingService.GetById(id);
            if (model == null)
                RedirectToAction("Add");
            return View(model);
        }

        [HttpPost]
        public async Task<IActionResult> Edit(BillingDetails model)
        {
            if (!ModelState.IsValid)
                return View(model);
            await _billingService.EditBillingDetailsAsync(model);
            return RedirectToAction("Index", "Cart");
        }

        [HttpPost]
        public async Task<IActionResult> Delete(int id)
        {
            await _billingService.DeleteBillingDetailsAsync(id);
            return RedirectToAction("Index", "Cart");
        }
    }
}
