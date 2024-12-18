﻿using Market.Data.Models;
using Market.Models;
using Market.Services;
using Market.Services.Cart;
using Market.Services.Firebase;
using Market.Data.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Market.Controllers
{
    public class CartController : Controller
    {
        private readonly ICartService _cartService;
        private readonly IFirebaseServive _firebaseService;
        private readonly IUserService _userService;
        public CartController(ICartService cartService, IUserService userService, IFirebaseServive firebaseService)
        {
            _cartService = cartService;
            _userService = userService;
            _firebaseService = firebaseService;
        }

        [HttpGet]
        public async Task<IActionResult> Index()
        {
            Purchase? purchase = _cartService.GetPurchase();
            if (purchase == null) purchase = new Purchase();

            List<string> urls = new List<string>();
            foreach(Order order in purchase.Orders)
            {
                urls.Add( await _firebaseService.GetImageUrl("offers", order.Offer.Id.ToString()));
            }

            ViewBag.ImageURLs = urls;

            return View(purchase);
        }

        [HttpPost]
        public IActionResult Add(Offer offer, double quantity)
        {
            User user = _userService.GetUser();
            double discount = HttpContext.User.IsInRole("Organization") ? ((100 - (double)offer.Discount) / 100) : 1;
            double price = offer.PricePerKG * discount * quantity;
            Order order = new Order()
            {
                Offer = offer,
                OfferId = offer.Id,
                Quantity = quantity,
                BuyerId = user.Id,
                SellerId = offer.OwnerId,
                Price = Math.Round(price, 2),
                Title = offer.Title
            };
            _cartService.AddOrder(order);
            return RedirectToAction("Index");
        }

        [HttpPost]
        public IActionResult Delete (int id)
        {
            _cartService.DeleteOrder(id);
            return RedirectToAction("Index");
        }

        [HttpPost]
        public IActionResult Quantity(int id, int quantity)
        {
            _cartService.UpdateQuantity(id, quantity);
            return RedirectToAction("Index");
        }

        [HttpPost]
        public async Task<IActionResult> Purchase(string address, int billingId)
        {
            await _cartService.Purchase(address, _userService.GetUser().Id, billingId);
            return RedirectToAction("Discover", "Offers");
        }

        [HttpGet]
        [Authorize(Roles = "Organization")]
        public IActionResult Billing()
        {
            BillingDetailsViewModel model = new BillingDetailsViewModel();
            return View(model);
        }

        [HttpPost]
        [Authorize(Roles = "Organization")]
        public async Task<IActionResult> Billing(BillingDetailsViewModel model)
        {
            if (!ModelState.IsValid)
                return View(model);
            await _cartService.CreateBillingDetailsAsync(model);
            return RedirectToAction("Index");
        }
    }
}
