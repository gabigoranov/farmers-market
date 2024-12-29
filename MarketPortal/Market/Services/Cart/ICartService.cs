using Market.Data.Models;
using Market.Models;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;

namespace Market.Services.Cart
{
    public interface ICartService
    {
        public List<Order>? GetPurchase();
        public Task AddOrder(Order order);
        public Task DeleteOrder(int id);
        public Task UpdateQuantity(int id, int quantity);
        public Task Purchase(string addres, Guid buyerId, int billingId);
        public List<BillingDetails> GetBillingDetails();
    }
}