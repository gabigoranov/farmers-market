using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using Microsoft.EntityFrameworkCore;
using System.Reflection.Metadata.Ecma335;

namespace MarketAPI.Services.Users
{
    public class UsersService : IUsersService
    {

        private readonly ApiContext _context;

        public UsersService(ApiContext context)
        {
            _context = context;
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
                        Password = user.Password,
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
                        Password = user.Password,
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
                        Password = user.Password,
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
            user.Password = model.Password;

            if(user is Organization organization)
            {
                organization.OrganizationName = model.OrganizationName!;
                user = organization;
            }

            _context.Entry(user).State = EntityState.Modified;
            _context.SaveChanges();
        }

        public async Task<User?> GetUserAsync(Guid id)
        {
            User? user = await _context.Users.FirstOrDefaultAsync(u => u.Id == id);
            if (user == null) return null;

            int discriminator = user.Discriminator;
            User? res = null;

            if (discriminator == 1)
            {
                res = await _context.Sellers.Include(x => x.Offers).Include(x=>x.SoldOrders).FirstOrDefaultAsync(u => u.Id == id);
            }
            else if (discriminator == 0)
            {
                res = await _context.Users.Include(x =>x.BoughtOrders).FirstOrDefaultAsync(u => u.Id == id);
            }
            else if (discriminator == 2)
            {
                res = await _context.Organizations.Include(x=>x.BoughtOrders).FirstOrDefaultAsync(u => u.Id == id);
            }

            return res;

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

            var user = await _context.Users.FirstOrDefaultAsync(u => u.Email == email && u.Password == password);
            if (user == null) return null;

            switch(user.Discriminator)
            {
                case 1:
                    user = await _context.Sellers.Include(x => x.Offers).Include(x => x.SoldOrders).FirstOrDefaultAsync(u => u.Email == email && u.Password == password);
                    break;
                case 2:
                    user = await _context.Users.Include(x => x.BoughtPurchases).Include(x => x.BoughtOrders).FirstOrDefaultAsync(u => u.Email == email && u.Password == password);
                    break;
                case 3:
                    user = await _context.Organizations.Include(x => x.BoughtOrders).FirstOrDefaultAsync(u => u.Email == email && u.Password == password);
                    break;

            }

            return user;
        }

        public async Task<bool> UserExistsAsync(AuthModel model)
        {
            return await _context.Users.AnyAsync(x => x.Email == model.Email && x.Password == model.Password);
        }
    }
}
