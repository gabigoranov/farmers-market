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
        private readonly User user;
        private readonly APIClient _client;

        public InventoryService(IUserService userService, APIClient client)
        {
            _userService = userService;
            user = userService.GetUser();
            this._client = client;
        }
        public async Task AddStockAsync(StockViewModel model)
        {
            model.SellerId = user.Id;
            string url = "https://farmers-api.runasp.net/api/inventory/";
            var response = await _client.PostAsync<string>(url, model);
        }

        public async Task DeleteStockAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/delete/{id}";
            var response = await _client.DeleteAsync<string>(url);
        }

        public async Task DownStockAsync(int id, double quantity)
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/decrease?id={id}";
            var response = await _client.PostAsync<string>(url, quantity);
        }

        public async Task<List<Stock>> GetSellerStocksAsync()
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/by-seller/{user.Id}";
            List<Stock>? response = await _client.GetAsync<List<Stock>>(url);
            return response!;
        }

        public async Task UpStockAsync(ChangeStockViewModel model)
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/increase/{model.Id}";
            var response = await _client.PostAsync<string>(url, model.Quantity);
        }
    }
}
