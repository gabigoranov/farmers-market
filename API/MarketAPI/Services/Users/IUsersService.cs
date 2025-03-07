﻿using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Users
{
    public interface IUsersService
    {
        public Task<UserDTO?> GetUserAsync(Guid id); 
        public Task DeleteUserAsync(Guid id); 
        public Task<List<PurchaseDTO>> GetUserHistory(Guid id); 
        public Task EditUserAsync(Guid id, EditUserViewModel model);
        public Task<UserDTO?> LoginAsync(AuthModel model);
        public Task CreateUserAsync(AddUserViewModel user);

        public Task<bool> UserExistsAsync(AuthModel model);
        public Task UpdateUserTokensAsync(Guid id);
        public string HashPassword(string password);
        public bool VerifyPassword(string hashedPassword, string enteredPassword);
        public Task<IEnumerable<OrderDTO>?> GetSellerOrdersAsync(Guid id);
        public Task<SellerDTO?> GetSellerAsync(Guid id);
        public Task<OrganizationDTO?> GetOrganizationAsync(Guid id);
        public Task<UserDTO?> GetUserEntityAsync(Guid id);


        Task<List<UserDTO>> GetUsersAsync(List<string> userIds);
    }
}
