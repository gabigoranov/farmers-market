using Market.Data.Models;
using Market.Models;
using System.Text.Json;
using System.Text;
using System.Reflection;
using Market.Data.Common.Handlers;

namespace Market.Services.Inventory
{
    public class InventoryService : IInventoryService
    {
        private readonly IUserService _userService;
        private User? _user;
        private readonly APIClient _client;
        private const string BASE_URL = "https://api.freshly-groceries.com/api/inventory/";

        public InventoryService(IUserService userService, APIClient client)
        {
            _userService = userService;
            _user = _userService.GetUser();
            this._client = client;
        }
        public async Task AddStockAsync(StockViewModel model)
        {
            if (_user == null)
                _user = _userService.GetUser();

            model.SellerId = _user.Id;
            var response = await _client.PostAsync<string>(BASE_URL, model);
        }

        public async Task DeleteStockAsync(int id)
        {
            var response = await _client.DeleteAsync<string>($"{BASE_URL}{id}");
        }

        public async Task DownStockAsync(int id, double quantity)
        {
            var response = await _client.PostAsync<string>($"{BASE_URL}decrease/{id}", quantity);
        }

        public async Task<List<Stock>> GetSellerStocksAsync()
        {
            if (_user == null)
                _user = _userService.GetUser();

            List<Stock>? response = await _client.GetAsync<List<Stock>>($"{BASE_URL}by-seller/{_user.Id}");
            return response!;
        }

        public async Task UpStockAsync(ChangeStockViewModel model)
        {
            if(_user == null)
                _user = _userService.GetUser();

            var response = await _client.PostAsync<string>($"{BASE_URL}increase/{model.Id}", model.Quantity);
        }
    }
}
