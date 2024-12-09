using MarketAPI.Data.Models;
using MarketAPI.Models;

namespace MarketAPI.Services.Orders
{
    public interface IOrdersService
    {
        public Task<Order> CreateOrderAsync(OrderViewModel model);
        public Task<ICollection<Order>> CreateOrdersAsync(ICollection<OrderViewModel> models);
        public List<Order> GetAllOrders();
        public Task<string> ApproveOrderAsync(int id);
        public Task<string> DeclineOrderAsync(int id);
        public Task<string> DeliverOrderAsync(int id);
    }
}
