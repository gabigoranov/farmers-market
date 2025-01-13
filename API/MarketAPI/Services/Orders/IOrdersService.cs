using MarketAPI.Data.Models;
using MarketAPI.Models;

namespace MarketAPI.Services.Orders
{
    public interface IOrdersService
    {
        public Task<Order> CreateOrderAsync(OrderViewModel model, int billingDetailsId);
        public Task<ICollection<Order>> CreateOrdersAsync(ICollection<OrderViewModel> models, int billingDetailsId);
        public List<Order> GetAllOrders();
        public Task<string> ApproveOrderAsync(int id);
        public Task<string> DeclineOrderAsync(int id);
        public Task<string> DeliverOrderAsync(int id);
        public Task<Order> GetOrderAsync(int id);
        public IEnumerable<Order>? GetSellerOrders(Guid id);
    }
}
