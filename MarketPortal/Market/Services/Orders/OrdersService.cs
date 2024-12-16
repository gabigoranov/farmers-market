
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
        private readonly IHttpContextAccessor _contextAccessor;
        private readonly APIClient _client;

        public OrdersService(APIClient client, IHttpContextAccessor contextAccessor)
        {
            this._client = client;
            _contextAccessor = contextAccessor;
        }


        public async Task ApproveOrderAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/orders/{id}/approve";
            var response = await _client.PutAsync<string>(url, null); 
        }

        public async Task DeclineOrderAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/orders/{id}/decline";
            var response = await _client.PutAsync<string>(url, null);
        }

        public async Task DeliverOrderAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/orders/{id}/deliver";
            var response = await _client.PutAsync<string>(url, null);
        }

        public async Task<Order> GetOrderAsync(int id)
        {
            var url = $"https://farmers-api.runasp.net/api/orders/{id}";
            var result = await _client.GetAsync<Order>(url);
            return result;
        }

        public async Task<List<OrderDTO>> GetUserOrders(Guid id)
        {
            var url = $"https://farmers-api.runasp.net/api/users/{id}/incoming";
            var result = await _client.GetAsync<List<OrderDTO>>(url);
            return result;
        }
    }
}
