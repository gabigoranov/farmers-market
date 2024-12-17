using Market.Data.Models;
using Market.Models;
using Microsoft.EntityFrameworkCore.Metadata.Conventions;

namespace Market.Services.Cart
{
    public interface ICartService
    {
        public Purchase? GetPurchase();
        public void AddOrder(Order order);
        public void EditOrder(Order order);
        public void DeleteOrder(int id);
        public void EmptyCart();
        public void UpdateQuantity(int id, int quantity);
        public Task Purchase(string addres, Guid buyerId);
        public Task<int> CreateBillingDetailsAsync(BillingDetailsViewModel model, Guid id);
    }
}
