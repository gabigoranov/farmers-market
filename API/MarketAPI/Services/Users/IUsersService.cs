using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Users
{
    public interface IUsersService
    {
        public Task<UserDTO?> GetUserAsync(Guid id); 
        public Task DeleteUserAsync(Guid id); 
        public Task<List<Purchase>> GetUserHistory(Guid id); 
        public Task EditUserAsync(Guid id, AddUserViewModel model);
        public Task<User?> LoginAsync(AuthModel model);
        public Task CreateUserAsync(AddUserViewModel user);

        public Task<bool> UserExistsAsync(AuthModel model);
        public Task UpdateUserTokensAsync(Guid id);
        public string HashPassword(string password);
        public bool VerifyPassword(string hashedPassword, string enteredPassword);
        public Task<IEnumerable<OrderDTO>?> GetSellerOrdersAsync(Guid id);
        public SellerDTO ConvertToSellerDTO(Seller user);
        public Task<List<User>> GetAllAsync();
        Task<List<User>> GetUsersAsync(List<string> userIds);
    }
}
