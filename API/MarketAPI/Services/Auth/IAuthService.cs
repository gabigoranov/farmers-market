using MarketAPI.Models;

namespace MarketAPI.Services.Auth
{
    public interface IAuthService
    {
        public string CreateNewToken(AuthModel model);
    }
}
