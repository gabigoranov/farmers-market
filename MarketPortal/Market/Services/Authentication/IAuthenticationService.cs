using Market.Data.Models;
using Market.Models;

namespace Market.Services.Authentication
{
    public interface IAuthenticationService
    {
        public Task Logout();
        public Task SignInAsync(string userdata, string role);
        public Task UpdateCart(Purchase purchase);
        public Task UpdateUserData(string userdata);
        public Task<string> GetAuthToken(AuthModel model);
    }
}
