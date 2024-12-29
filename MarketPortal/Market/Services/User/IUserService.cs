using Market.Data.Models;
using Market.Models;
using System.Net;

namespace Market.Services
{
    public interface IUserService
    {
        public Task<User> Login(AuthModel model);
        public Task Register(UserViewModel user, int discriminator);
        public Task RemoveOrderAsync(int orderId);
        public Task DeclineOrderAsync(int orderId);
        public User GetUser();

        Task AddApprovedOrderAsync(int id);
        Task AddDeliveredOrder(int id);
        Task<List<Purchase>> GetUserBoughtPurchases();
    }
}