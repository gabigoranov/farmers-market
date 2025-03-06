using Market.Services.Firebase;
using Market.Services.Offers;
using Market.Services;
using Microsoft.AspNetCore.Mvc;
using Market.Services.Orders;
using Market.Data.Models;
using Market.Services.Authentication;
using System.Text.Json;
using System.Diagnostics;
using Microsoft.AspNetCore.Authorization;
using Market.Data.Common.Handlers;

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

        //TODO: move into service
        private readonly APIClient _client;


        public OrdersController(IUserService userService
            , IFirebaseServive firebaseService, IOrdersService ordersService, IAuthService authService, APIClient client)
        {
            _userService = userService;
            _firebaseService = firebaseService;
            user = _userService.GetUser();
            _ordersService = ordersService;
            _authService = authService;
            _client = client;
        }
        public async Task<IActionResult> Index(List<Order>? orders)
        {
            if(orders != null && orders.Count > 0)
                return View(orders);

            user.SoldOrders = await _ordersService.GetUserOrders(user.Id);
            await _authService.UpdateUserData(user);

            return View(user.SoldOrders.ToList());
        }

        [HttpGet]
        public async Task<IActionResult> Statistics()
        {
            user.SoldOrders = await _ordersService.GetUserOrders(user.Id);
            return View(user.SoldOrders);
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

        [HttpGet]
        public async Task<IActionResult> Description(int id)
        {

            Order order = await _ordersService.GetOrderAsync(id);
            return View(order);
        }

        
    }
}
