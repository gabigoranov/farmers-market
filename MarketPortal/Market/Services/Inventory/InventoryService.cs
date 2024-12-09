using Market.Data.Models;
using Market.Models;
using System.Text.Json;
using System.Text;
using System.Reflection;

namespace Market.Services.Inventory
{
    public class InventoryService : IInventoryService
    {
        private readonly IHttpClientFactory _httpClientFactory;
        private readonly IUserService _userService;
        private readonly User user;
        private readonly HttpClient client;

        public InventoryService(IHttpClientFactory httpClientFactory, IUserService userService)
        {
            _httpClientFactory = httpClientFactory;
            client = _httpClientFactory.CreateClient();
            client.BaseAddress = new Uri("https://farmers-api.runasp.net/api/");
            _userService = userService;
            user = userService.GetUser();
        }
        public async Task AddStockAsync(StockViewModel model)
        {
            model.SellerId = user.Id;

            string url = "https://farmers-api.runasp.net/api/inventory/";
            var jsonParsed = JsonSerializer.Serialize<StockViewModel>(model, new JsonSerializerOptions() { PropertyNamingPolicy = JsonNamingPolicy.CamelCase });
            HttpContent content = new StringContent(jsonParsed.ToString(), Encoding.UTF8, "application/json");
            var response = await client.PostAsync(url, content);
        }

        public async Task DeleteStockAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/delete/{id}";
            var response = await client.DeleteAsync(url);
        }

        public async Task DownStockAsync(int id, double quantity)
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/decrease?id={id}";
            var response = await client.PostAsJsonAsync(url, quantity);
        }

        public async Task<List<Stock>> GetSellerStocksAsync()
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/by-seller/{user.Id}";
            List<Stock>? response = await client.GetFromJsonAsync<List<Stock>>(url);
            return response!;
        }

        public async Task UpStockAsync(ChangeStockViewModel model)
        {
            string url = $"https://farmers-api.runasp.net/api/inventory/increase/{model.Id}";
            var response = await client.PostAsJsonAsync(url, model.Quantity);
        }
    }
}
