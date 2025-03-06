using Market.Data.Common.Handlers;
using Market.Data.Models;
using Newtonsoft.Json;

namespace Market.Services.Cart
{
    public class CartService : ICartService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly Authentication.IAuthService _authService;
        private readonly IUserService _userService;
        private readonly APIClient _client;
        private List<Order>? _orders;

        public CartService(IHttpContextAccessor httpContextAccessor, Authentication.IAuthService authService, APIClient clients, IUserService userService)
        {
            _orders = GetPurchase();
            this._httpContextAccessor = httpContextAccessor;
            _authService = authService;
            _client = clients;
            _userService = userService;
        }

        public async Task AddOrder(Order order)
        {
            GetPurchase();
            _orders!.Add(order);
            await _authService.UpdateCart(_orders, order.BuyerId);
        }

        public async Task DeleteOrder(int id)
        {
            GetPurchase();
            _orders!.RemoveAt(id);
            await _authService.UpdateCart(_orders, _userService.GetUser().Id);
        }

        public List<BillingDetails> GetBillingDetails()
        {
            User user = _userService.GetUser();
            return user.BillingDetails ?? [];
        }

        public List<Order>? GetPurchase()
        {
            try
            {
                var claim = _httpContextAccessor?.HttpContext?.Session?.GetString("Cart");
                if (claim == null)
                {
                    return new List<Order>();
                }
                _orders = JsonConvert.DeserializeObject<List<Order>>(claim);
            }
            catch (Exception ex)
            {
                return null;
            }
            return _orders;
        }

        public async Task Purchase(string address, Guid buyerId, int billingId)
        {
            //Setup purchase model using the neccessary data
            GetPurchase();
            Purchase model = new Purchase();
            model.Orders = _orders ?? [];
            model.Address = address;
            model.BuyerId = buyerId;
            model.Price = model.Orders.Select(x => x.Price).Sum();
            model.BillingDetailsId = billingId;
            foreach (Order order in model.Orders)
            {
                order.Address = address;
                order.BuyerId = _userService.GetUser().Id;
                order.SellerId = order.Offer.OwnerId;
                order.BillingDetailsId = billingId;
            }
            var testing = JsonConvert.SerializeObject(model);
            string url = "https://api.freshly-groceries.com/api/purchases/";
            var result = await _client.PostAsync<string>(url, model);
            _orders = new List<Order>();
            await _authService.UpdateCart(_orders, buyerId);

        }

        public async Task UpdateQuantity(int id, int quantity)
        {
            GetPurchase();
            _orders![id].Quantity = quantity;
            _orders![id].Price = quantity * _orders![id].Offer!.PricePerKG;
            await _authService.UpdateCart(_orders, _orders[0].BuyerId);
        }
    }
}