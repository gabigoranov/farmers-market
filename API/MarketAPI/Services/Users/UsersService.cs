using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Notifications;
using MarketAPI.Services.Token;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Metadata.Ecma335;
using System.Security.Claims;

namespace MarketAPI.Services.Users
{
    public class UsersService : IUsersService
    {
        private readonly IPasswordHasher<string> _passwordHasher;
        private readonly ApiContext _context;
        private readonly TokenService _tokenService;
        private readonly IMapper _mapper;
        private readonly INotificationsService _notificationsService;

        public UsersService(ApiContext context, IPasswordHasher<string> passwordHasher, TokenService tokenService, IMapper mapper, INotificationsService notificationsService)
        {
            _context = context;
            _passwordHasher = passwordHasher;
            _tokenService = tokenService;
            _mapper = mapper;
            _notificationsService = notificationsService;
        }

        public string HashPassword(string password)
        {
            return _passwordHasher.HashPassword(null, password);
        }

        public bool VerifyPassword(string hashedPassword, string enteredPassword)
        {
            var result = _passwordHasher.VerifyHashedPassword(null, hashedPassword, enteredPassword);
            return result == PasswordVerificationResult.Success;
        }

        public async Task CreateUserAsync(AddUserViewModel user)
        {
            if (!_context.Users.Any(u => u.Email == user.Email))
            {
                user.Password = HashPassword(user.Password);

                if (user.Discriminator == 0)
                {
                    var res = _mapper.Map<User>(user);


                    await _context.Users.AddAsync(res);
                    NotificationPreferences pref = await _notificationsService.CreatePreferencesAsync(new NotificationPreferences() { UserId = res.Id}, false);
                    res.NotificationPreferences = pref;

                }
                else if (user.Discriminator == 1)
                {
                    var res = _mapper.Map<Seller>(user);
                    await _context.Sellers.AddAsync(res);
                    NotificationPreferences pref = await _notificationsService.CreatePreferencesAsync(new NotificationPreferences() { UserId = res.Id }, false);
                    res.NotificationPreferences = pref;
                }
                else if (user.Discriminator == 2)
                {
                    var res = _mapper.Map<Organization>(user);
                    await _context.Organizations.AddAsync(res);
                    NotificationPreferences pref = await _notificationsService.CreatePreferencesAsync(new NotificationPreferences() { UserId = res.Id }, false);
                    res.NotificationPreferences = pref;
                }

                await _context.SaveChangesAsync();
            }
            else
            {
                throw new InvalidDataException("User already exists in database");
            }
        }

        public async Task DeleteUserAsync(Guid id)
        {
            var user = await _context.Users.SingleOrDefaultAsync(x => x.Id == id);
            if (user == null) throw new ArgumentNullException(nameof(user), "User with specified id does not exist.");

            _context.Users.Remove(user);
            await _context.SaveChangesAsync();
        }

        public async Task EditUserAsync(Guid id, EditUserViewModel model)
        {
            User? user = await _context.Users.FindAsync(id);
            if (user == null) throw new ArgumentNullException(nameof(user), "User with specified id does not exist.");

            _context.Update(user);

            user.Email = model.Email;
            user.BirthDate = model.BirthDate;
            user.FirstName = model.FirstName;
            user.LastName = model.LastName; 
            user.PhoneNumber = model.PhoneNumber;
            user.Description = model.Description;
            user.Town = model.Town;

            if(user is Organization organization)
            {
                organization.OrganizationName = model.OrganizationName!;
                user = organization;
            }

            await _context.SaveChangesAsync();
        }


        public async Task<UserDTO?> GetUserAsync(Guid id)
        {
            User? user = await _context.Users.Include(x => x.BillingDetails).Include(x => x.BoughtOrders).Include(x => x.BoughtPurchases).Include(x => x.Token).FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) return null;

            switch (user.Discriminator)
            {
                case 1:
                    SellerDTO? seller = await GetSellerAsync(user.Id);
                    return seller;
                case 0:
                    UserDTO? res = await GetUserEntityAsync(user.Id);
                    return res;
                case 2:
                    OrganizationDTO? org = await GetOrganizationAsync(user.Id);
                    return org;
            }

            return null;
        }

        public async Task<UserDTO?> GetUserEntityAsync(Guid id)
        {
            User? user = await _context.Users.Include(x => x.BillingDetails).Include(x => x.BoughtOrders).Include(x => x.BoughtPurchases).Include(x => x.Token).Include(x => x.NotificationPreferences).FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) return null;

            _context.Update(user);
            user.Token = await _tokenService.CreateTokenAsync(user.Id);
            _context.Update(user.Token);
            user.TokenId = user.Token.Id;
            user.Token.AccessToken = _tokenService.GenerateAccessToken(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, user.Discriminator == 0 ? "User" : user.Discriminator == 1 ? "Seller" : "Organization")
            });

            UserDTO dto = _mapper.Map<UserDTO>(user);

            return dto;

        }

        public async Task<OrganizationDTO?> GetOrganizationAsync(Guid id)
        {
            Organization? user = await _context.Organizations.Include(x => x.BillingDetails).Include(x => x.BoughtOrders).Include(x => x.Token).Include(x => x.NotificationPreferences).FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) return null;

            _context.Update(user);
            user.Token = await _tokenService.CreateTokenAsync(user.Id);
            _context.Update(user.Token);
            user.TokenId = user.Token.Id;
            user.Token.AccessToken = _tokenService.GenerateAccessToken(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, user.Discriminator == 0 ? "User" : user.Discriminator == 1 ? "Seller" : "Organization")
            });

            OrganizationDTO dto = _mapper.Map<OrganizationDTO>(user);

            return dto;

        }

        public async Task<SellerDTO?> GetSellerAsync(Guid id)
        {
            Seller? user = await _context.Sellers.Include(x => x.BillingDetails).Include(x => x.Offers).Include(x => x.Token).Include(x => x.SoldOrders).FirstOrDefaultAsync(u => u.Id == id);

            if (user == null) return null;

            _context.Update(user);
            user.Token = await _tokenService.CreateTokenAsync(user.Id);
            _context.Update(user.Token);
            user.TokenId = user.Token.Id;
            user.Token.AccessToken = _tokenService.GenerateAccessToken(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, user.Discriminator == 0 ? "User" : user.Discriminator == 1 ? "Seller" : "Organization")
            });

            SellerDTO dto = _mapper.Map<SellerDTO>(user);

            return dto;

        }

        public async Task<List<PurchaseDTO>> GetUserHistory(Guid id)
        {
            var user = await _context.Users.Include(x => x.BoughtPurchases).ThenInclude(x => x.Orders).SingleOrDefaultAsync(x => x.Id == id);
            if (user == null) throw new ArgumentNullException(nameof(user), "User with specified id does not exist.");

            return _mapper.Map<List<PurchaseDTO>>(user.BoughtPurchases.ToList());
        }

        public async Task<UserDTO?> LoginAsync(AuthModel model)
        {
            string email = model.Email;
            string password = model.Password;

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);

            if (user == null) return null;
            if (!VerifyPassword(user.Password, model.Password)) return null;

            switch (user.Discriminator)
            {
                case 1:
                    SellerDTO? seller = await GetSellerAsync(user.Id);
                    return seller;
                case 0:
                    UserDTO? res = await GetUserAsync(user.Id);
                    return res;
                case 2:
                    OrganizationDTO? org = await GetOrganizationAsync(user.Id);
                    return org;
            }

            return null;

        }

        public async Task UpdateUserTokensAsync(Guid id)
        {
            User? user = await _context.Users.Include(x => x.Token).SingleOrDefaultAsync(x => x.Id == id);
            if(user == null) throw new ArgumentNullException(nameof(user), "User with specified id does not exist.");
            _context.Users.Update(user);
            if (user?.Token == null)
            {
                user!.Token = await _tokenService.CreateTokenAsync(id);
            }
            else
            {
                user.Token.ExpiryDateTime = DateTime.UtcNow.AddDays(30);
            }
            await _context.SaveChangesAsync();
        }

        public async Task<bool> UserExistsAsync(AuthModel model)
        {
            return await _context.Users.AnyAsync(x => x.Email == model.Email && x.Password == model.Password);
        }

        public async Task<IEnumerable<OrderDTO>?> GetSellerOrdersAsync(Guid id)
        {
            Seller? user = await _context.Sellers.Include(x => x.SoldOrders).ThenInclude(x => x.BillingDetails).AsNoTracking().SingleOrDefaultAsync(x => x.Id == id);

            return _mapper.Map<List<OrderDTO>?>(user?.SoldOrders) ?? new List<OrderDTO>();
        }

        public async Task<List<UserDTO>> GetUsersAsync(List<string> userIds)
        {
            var users = await _context.Users
                .AsNoTracking()
                .ToListAsync();

            // Iterate over users and include Organization-specific fields if the user is an Organization
            foreach (User user in users)
            {
                if (user is Organization organization)
                {
                    // Include Organization-specific properties
                    // For example, you could populate the OrganizationName if needed
                    user.FirstName = organization.OrganizationName;
                }
            }

            List<User> res = users.Where(x => userIds.Contains(x.Id.ToString())).ToList();
            return _mapper.Map<List<UserDTO>>(res);
        }
    }

    
}
