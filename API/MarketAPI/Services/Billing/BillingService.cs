using MarketAPI.Data;
using MarketAPI.Data.Models;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Billing
{
    public class BillingService : IBillingService
    {
        private readonly ApiContext _context;
        public BillingService(ApiContext context)
        {
            _context = context;
        }

        public async Task<int> CreateAsync(BillingDetails model)
        {
            if(!await _context.Users.AnyAsync(x => x.Id == model.UserId)) 
                throw new KeyNotFoundException("User with specified id does not exist.");

            await _context.BillingDetails.AddAsync(model);
            await _context.SaveChangesAsync();

            return model.Id;
        }

        public async Task DeleteAsync(int id)
        {
            var model = await _context.BillingDetails.FindAsync(id);
            if (model == null)
                throw new KeyNotFoundException("BillingDetails with specified id do not exist.");
            _context.BillingDetails.Remove(model);
            await _context.SaveChangesAsync();
        }

        public async Task EditAsync(int id, BillingDetails model)
        {
            BillingDetails? entity = await _context.BillingDetails.SingleOrDefaultAsync(x => x.Id == id);
            if(entity == null)
                throw new KeyNotFoundException("BillingDetails with specified id do not exist.");

            _context.Update(entity);

            entity.Address = model.Address;
            entity.City = model.City;
            entity.Email = model.Email;
            entity.FullName = model.FullName;
            entity.PhoneNumber = model.PhoneNumber;
            entity.PostalCode = model.PostalCode;

            await _context.SaveChangesAsync();

        }

        public async Task<BillingDetails> GetAsync(int id)
        {
            BillingDetails? entity = await _context.BillingDetails.FindAsync(id);
            if (entity == null)
                throw new KeyNotFoundException("BillingDetails with specified id do not exist.");

            return entity;
        }
    }
}
