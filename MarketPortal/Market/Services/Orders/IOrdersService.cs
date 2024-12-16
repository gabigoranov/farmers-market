using Market.Data.Models;
using Market.Models.DTO;

namespace Market.Services.Orders
{
    public interface IOrdersService
    {
        public Task ApproveOrderAsync(int id);
        public Task DeclineOrderAsync(int id);
        public Task DeliverOrderAsync(int id);
        public Task<Order> GetOrderAsync(int id);
        public Task<List<OrderDTO>> GetUserOrders(Guid id);
    }
}
