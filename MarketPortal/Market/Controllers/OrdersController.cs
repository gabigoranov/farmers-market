﻿using Market.Services.Firebase;
using Market.Services.Offers;
using Market.Services;
using Microsoft.AspNetCore.Mvc;
using Market.Services.Orders;
using Market.Data.Models;
using Market.Services.Authentication;
using System.Text.Json;
using System.Diagnostics;
using Microsoft.AspNetCore.Authorization;

namespace Market.Controllers
{
    [Authorize]
    public class OrdersController : Controller
    {
        private readonly IUserService _userService;
        private readonly IAuthService _authService;
        private readonly IFirebaseServive _firebaseService;
        private readonly IOrdersService _ordersService;
        private User user;



        public OrdersController(IUserService userService, IFirebaseServive firebaseService, IOrdersService ordersService, IAuthService authService)
        {
            _userService = userService;
            _firebaseService = firebaseService;
            user = _userService.GetUser();
            _ordersService = ordersService;
            _authService = authService;
        }
        public async Task<IActionResult> IndexAsync(List<Order>? orders)
        {
            if(orders != null && orders.Count > 0)
                return View(orders);

            user = await _userService.Login(new Models.AuthModel(user.Email, user.Password));

            await _authService.UpdateUserData(JsonSerializer.Serialize<User>(user));

            return View(user?.SoldOrders?.ToList());
        }

        [HttpGet]
        public async Task<IActionResult> Approve(int id)
        {
            await _ordersService.ApproveOrderAsync(id);
            await _userService.AddApprovedOrderAsync(id);
            return RedirectToAction("Index");
        }

        [HttpGet]
        public async Task<IActionResult> Decline(int id)
        {
            await _ordersService.DeclineOrderAsync(id);
            await _userService.DeclineOrderAsync(id);
            return RedirectToAction("Index");
        }

        [HttpPost]
        public IActionResult Sort(List<Order> orders, string type)
        {
            orders = orders.OrderByDescending(x => x.Price).ToList();
            return RedirectToAction("Index", orders);
        }

        [HttpGet]
        public async Task<IActionResult> Deliver(int id)
        {
            await _ordersService.DeliverOrderAsync(id);
            await _userService.AddDeliveredOrder(id);
            return RedirectToAction("Index");
        }

        [HttpGet]
        public async Task<IActionResult> History()
        {
            List<Purchase> purchases = await _userService.GetUserBoughtPurchases();
            ViewBag.imageURLs = await _firebaseService.GetPurchasesImages(purchases);

            return View(purchases);
        }
    }
}
