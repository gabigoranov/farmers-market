using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Orders
{
    public interface IOrdersService
    {
        public Task<Order> CreateOrderAsync(OrderViewModel model, int billingDetailsId);
        public Task<List<Order>> CreateOrdersAsync(ICollection<OrderViewModel> models, int billingDetailsId);
        public List<OrderDTO> GetAllOrders();
        public Task<string> ApproveOrderAsync(int id);
        public Task<string> DeclineOrderAsync(int id);
        public Task<string> DeliverOrderAsync(int id);
        public Task<OrderDTO> GetOrderAsync(int id);
        public IEnumerable<OrderDTO>? GetSellerOrders(Guid id);
    }
}
