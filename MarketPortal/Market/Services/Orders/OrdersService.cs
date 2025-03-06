
using Market.Data.Common.Handlers;
using Market.Data.Models;
using Market.Models.DTO;
using Microsoft.VisualStudio.Web.CodeGenerators.Mvc.Templates.BlazorIdentity.Pages.Manage;
using System.Security.Claims;
using System.Text.Json;

namespace Market.Services.Orders
{
    public class OrdersService : IOrdersService
    {
        private readonly APIClient _client;
        private const string BASE_URL = "https://api.freshly-groceries.com/api/orders/";
        public OrdersService(APIClient client)
        {
            this._client = client;
        }


        public async Task ApproveOrderAsync(int id)
        {
            string url = $"{id}/approve";
            var response = await _client.PutAsync<string>($"{BASE_URL}{id}/approve", String.Empty); 
        }

        public async Task DeclineOrderAsync(int id)
        {
            var response = await _client.PutAsync<string>($"{BASE_URL}{id}/decline", String.Empty);
        }

        public async Task DeliverOrderAsync(int id)
        {
            var response = await _client.PutAsync<string>($"{BASE_URL}{id}/deliver", String.Empty);
        }

        public async Task<Order> GetOrderAsync(int id)
        {
            var result = await _client.GetAsync<Order>($"{BASE_URL}{id}");
            return result;
        }

        public async Task<List<OrderDTO>> GetUserOrders(Guid id)
        {
            var url = $"https://api.freshly-groceries.com/api/users/{id}/incoming";
            var result = await _client.GetAsync<List<OrderDTO>>(url);
            return result;
        }
    }
}
