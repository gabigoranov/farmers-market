using Market.Data.Models;
using Market.Models;

namespace Market.Services.Authentication
{
    public interface IAuthService
    {
        public Task Logout();
        public Task SignInAsync(User userdata, string role);
        public Task UpdateCart(List<Order> purchase, Guid id);
        public Task UpdateUserData(User user);
        public Task LoadCartAsync(Guid id);
        //public Task SaveJWTDataAsync(Token token); 

    }
}