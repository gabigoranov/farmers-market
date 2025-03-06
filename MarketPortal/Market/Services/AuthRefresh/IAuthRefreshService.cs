using Market.Data.Models;

namespace Market.Services.AuthRefresh
{
    public interface IAuthRefreshService
    {
        public Task<User?> TryRefreshToken(string refreshToken);
        public Task<User?> TryRefreshUserData();
    }
}
