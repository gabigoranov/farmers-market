
using Market.Data.Common.Handlers;
using Market.Data.Models;
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
            string url = $"https://farmers-api.runasp.net/api/orders/accept?id={id}";
            var response = await _client.GetAsync<string>(url); 
        }

        public async Task DeclineOrderAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/orders/decline?id={id}";
            var response = await _client.GetAsync<string>(url);
        }

        public async Task DeliverOrderAsync(int id)
        {
            string url = $"https://farmers-api.runasp.net/api/orders/deliver?id={id}";
            var response = await _client.GetAsync<string>(url);
        }

        public async Task<List<Order>> GetUserOrders(Guid id)
        {
            var url = $"https://farmers-api.runasp.net/api/orders/";
            var result = await _client.GetAsync<List<Order>>(url);
            return result;
        }
    }
}
