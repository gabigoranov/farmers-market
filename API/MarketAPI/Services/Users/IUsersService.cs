using MarketAPI.Data.Models;
using MarketAPI.Models;

namespace MarketAPI.Services.Users
{
    public interface IUsersService
    {
        public Task<User?> GetUserAsync(Guid id); 
        public Task DeleteUserAsync(Guid id); 
        public Task<List<Purchase>> GetUserHistory(Guid id); 
        public Task EditUserAsync(Guid id, AddUserViewModel model);
        public Task<User?> LoginAsync(AuthModel model);
        public Task CreateUserAsync(AddUserViewModel user);

        public Task<bool> UserExistsAsync(AuthModel model);
        public Task UpdateUserTokensAsync(Guid id);
        public string HashPassword(string password);
        public bool VerifyPassword(string hashedPassword, string enteredPassword);

    }
}
