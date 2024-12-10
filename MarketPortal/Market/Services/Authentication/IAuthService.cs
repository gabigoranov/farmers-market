using Market.Data.Models;
using Market.Models;

namespace Market.Services.Authentication
{
    public interface IAuthService
    {
        public Task Logout();
        public Task SignInAsync(User userdata, string role);
        public Task UpdateCart(Purchase purchase);
        public Task UpdateUserData(string userdata);
        public Task<string> GetAuthToken(Guid id);

    }
}
