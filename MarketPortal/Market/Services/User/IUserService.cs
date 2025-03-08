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

        public Task<List<User>> GetAllAsync();

        Task AddApprovedOrderAsync(int id);
        Task AddDeliveredOrder(int id);
        Task<List<Purchase>> GetUserBoughtPurchases();
        Task<List<ContactViewModel>> ConvertToContacts(List<User> users);
        Task SaveReviewsAsync(List<Review> reviews);
        public Task<dynamic> GetStatisticsAsync();
        Task RegisterOrganization(OrganizationViewModel user, int v);
    }
}