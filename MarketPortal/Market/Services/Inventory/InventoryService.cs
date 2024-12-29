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
        private readonly User _user;
        private readonly APIClient _client;
        private const string BASE_URL = "https://farmers-api.runasp.net/api/inventory/";

        public InventoryService(IUserService userService, APIClient client)
        {
            _userService = userService;
            _user = userService.GetUser();
            this._client = client;
        }
        public async Task AddStockAsync(StockViewModel model)
        {
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
            List<Stock>? response = await _client.GetAsync<List<Stock>>($"{BASE_URL}by-seller/{_user.Id}");
            return response!;
        }

        public async Task UpStockAsync(ChangeStockViewModel model)
        {
            var response = await _client.PostAsync<string>($"{BASE_URL}increase/{model.Id}", model.Quantity);
        }
    }
}
