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
            Purchase purchase = new Purchase();
            List<Order>? orders = _cartService.GetPurchase();
            if (orders == null) orders = new List<Order>();

            purchase.Orders = orders;

            List<string> urls = new List<string>();
            foreach(Order order in orders)
            {
                purchase.Price += Math.Round(order.Price, 2);
                urls.Add( await _firebaseService.GetImageUrl("offers", order.Offer.Id.ToString()));
            }

            ViewBag.ImageURLs = urls;

            return View(purchase);
        }

        [HttpPost]
        public IActionResult Add(Offer offer, decimal quantity, int offerTypeId)
        {
            User user = _userService.GetUser();
            decimal discount = HttpContext.User.IsInRole("Organization") ? ((100 - (decimal)offer.Discount) / 100) : 1;
            decimal price = Math.Round(offer.PricePerKG * discount * quantity, 2);
            Order order = new Order()
            {
                Offer = offer,
                OfferId = offer.Id,
                Quantity = quantity,
                BuyerId = user.Id,
                SellerId = offer.OwnerId,
                Price = Math.Round(price, 2),
                OfferTypeId = offerTypeId,
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

        
    }
}
