using MarketAPI.Data.Models;
using MarketAPI.Models;

namespace MarketAPI.Services.Orders
{
    public interface IOrdersService
    {
        public Task<Order> AddOrderAsync(OrderViewModel order);
        public Task<ICollection<Order>> AddOrdersAsync(ICollection<OrderViewModel> orders);
    }
}
