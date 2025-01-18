using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Token;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Metadata.Ecma335;

namespace MarketAPI.Services.Users
{
    public class UsersService : IUsersService
    {
        private readonly IPasswordHasher<string> _passwordHasher;
        private readonly ApiContext _context;
        private readonly TokenService _tokenService;
        private readonly IMapper _mapper;

        public UsersService(ApiContext context, IPasswordHasher<string> passwordHasher, TokenService tokenService, IMapper mapper)
        {
            _context = context;
            _passwordHasher = passwordHasher;
            _tokenService = tokenService;
            _mapper = mapper;
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
                if (user.Discriminator == 0)
                {
                    _context.Users.Add(new User() //
                    {
                        FirstName = user.FirstName,
                        LastName = user.LastName,
                        Email = user.Email,
                        PhoneNumber = user.PhoneNumber,
                        Age = user.Age,
                        Description = user.Description,
                        Password = HashPassword(user.Password),
                        Town = user.Town,
                        Discriminator = user.Discriminator,
                    });
                }
                else if (user.Discriminator == 1)
                {
                    _context.Sellers.Add(new Seller() //
                    {
                        FirstName = user.FirstName,
                        LastName = user.LastName,
                        Email = user.Email,
                        PhoneNumber = user.PhoneNumber,
                        Age = user.Age,
                        Description = user.Description,
                        Password = HashPassword(user.Password),
                        Town = user.Town,
                        Discriminator = user.Discriminator,
                    });
                }
                else if (user.Discriminator == 2)
                {
                    Organization organization = new Organization()
                    {
                        Email = user.Email,
                        PhoneNumber = user.PhoneNumber,
                        Description = user.Description,
                        Password = HashPassword(user.Password),
                        Town = user.Town,
                        Discriminator = user.Discriminator,
                        OrganizationName = user.OrganizationName!
                    };

                    _context.Organizations.Add(organization);
                }
                await _context.SaveChangesAsync();
                string name = user.Discriminator! != 2 ? user.FirstName! : user.OrganizationName!;
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

        public async Task EditUserAsync(Guid id, AddUserViewModel model)
        {
            User? user = await _context.Users.FindAsync(id);
            if (user == null) throw new ArgumentNullException(nameof(user), "User with specified id does not exist.");

            _context.Update(user);

            user.Age = model.Age;
            user.PhoneNumber = model.PhoneNumber;
            user.Email = model.Email;
            user.FirstName = model.FirstName;
            user.LastName = model.LastName;
            user.Description = model.Description;
            user.Town = model.Town;
            user.Password = HashPassword(model.Password);

            if(user is Organization organization)
            {
                organization.OrganizationName = model.OrganizationName!;
                user = organization;
            }

            _context.Entry(user).State = EntityState.Modified;
            _context.SaveChanges();
        }

        public async Task<UserDTO?> GetUserAsync(Guid id)
        {
            User? user = await _context.Users.FirstOrDefaultAsync(u => u.Id == id);
            if (user == null) return null;

            int discriminator = user.Discriminator;
            User? res = null;

            if (discriminator == 1)
            {
                res = await _context.Sellers.Include(x => x.BillingDetails).Include(x => x.Offers).Include(x => x.Token).Include(x=>x.SoldOrders).FirstOrDefaultAsync(u => u.Id == id);
            }
            else if (discriminator == 0)
            {
                res = await _context.Users.Include(x => x.BillingDetails).Include(x =>x.BoughtOrders).Include(x => x.BoughtPurchases).Include(x => x.Token).FirstOrDefaultAsync(u => u.Id == id);
            }
            else if (discriminator == 2)
            {
                res = await _context.Organizations.Include(x => x.BillingDetails).Include(x=>x.BoughtOrders).Include(x => x.Token).FirstOrDefaultAsync(u => u.Id == id);
            }

            UserDTO dto = _mapper.Map<UserDTO>(res);
            return dto;

        }

        public async Task<List<Purchase>> GetUserHistory(Guid id)
        {
            var user = await _context.Users.Include(x => x.BoughtPurchases).ThenInclude(x => x.Orders).SingleOrDefaultAsync(x => x.Id == id);
            if (user == null) throw new ArgumentNullException(nameof(user), "User with specified id does not exist.");

            return user.BoughtPurchases.ToList();
        }

        public async Task<User?> LoginAsync(AuthModel model)
        {
            string email = model.Email;
            string password = model.Password;

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email);

            if (user == null) return null;
            if (!VerifyPassword(user.Password, model.Password)) return null;

            switch (user.Discriminator)
            {
                case 1:
                    Seller? seller = await _context.Sellers.Include(x => x.BillingDetails).Include(x => x.Offers).Include(x => x.SoldOrders).FirstOrDefaultAsync(u => u.Email == email);
                    return seller;
                case 0:
                    User? res = await _context.Users.Include(x => x.BillingDetails).Include(x => x.BoughtPurchases).Include(x => x.BoughtOrders).FirstOrDefaultAsync(u => u.Email == email);
                    return res;
                case 2:
                    Organization? org = await _context.Organizations.Include(x => x.BillingDetails).Include(x => x.BoughtOrders).FirstOrDefaultAsync(u => u.Email == email);
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
            Seller? user = await _context.Sellers.AsNoTracking().SingleOrDefaultAsync(x => x.Id == id);
            return user?.SoldOrders.Select(x => new OrderDTO() 
            { 
                Address = x.Address,
                SellerId = x.SellerId,
                BuyerId = x.BuyerId,
                DateDelivered = x.DateDelivered,
                DateOrdered = x.DateOrdered,
                Id = x.Id,
                IsAccepted = x.IsAccepted,
                IsDelivered = x.IsDelivered,
                IsDenied = x.IsDenied,
                OfferId = x.OfferId,
                Price = x.Price,
                Quantity = x.Quantity,
                Title = x.Title,
            }) ?? new List<OrderDTO>();
        }

        public SellerDTO ConvertToSellerDTO(Seller user)
        {
            IEnumerable<Review> reviews = user.Offers.SelectMany(x => x.Reviews);
            SellerDTO res = new SellerDTO()
            {
                Age = user.Age,
                Description = user.Description,
                Discriminator = user.Discriminator,
                Email = user.Email,
                FirstName = user.FirstName,
                Id = user.Id,
                LastName = user.LastName,
                Offers = user.Offers,
                OrdersCount = user.SoldOrders.Count,
                PhoneNumber = user.PhoneNumber,
                ReviewsCount = reviews.Count(),
                PositiveReviewsCount = reviews.Select(x => x.Rating > 2.5).Count(),
                Town = user.Town,
            };
            return res;
        }

        //Get all users in the db (used for development)
        public async Task<List<User>> GetAllAsync()
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

            return users;
        }

        public async Task<List<User>> GetUsersAsync(List<string> userIds)
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
            return res;
        }
    }

    
}
