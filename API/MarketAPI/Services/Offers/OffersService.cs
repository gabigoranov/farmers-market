using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Offers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.Net;

namespace MarketAPI.Services.Offers
{
    public class OffersService : IOffersService
    {
        private readonly ApiContext _context;

        public OffersService(ApiContext apiContext)
        {
            this._context = apiContext;
        }

        public async Task AddOffer(Offer offer)
        {
            await _context.AddAsync(offer);
            await _context.SaveChangesAsync();

        }

        public async Task EditAsync(OfferViewModel offerEdit)
        {
            Offer offer =  await _context.Offers.Include(x => x.Owner).SingleAsync(x => x.Id == offerEdit.Id);
            _context.Update(offer);

            offer.Title = offerEdit.Title;
            offer.PricePerKG = offerEdit.PricePerKG;
            offer.StockId = offerEdit.StockId;
            offer.Description = offerEdit.Description;

            _context.Entry(offer).State = EntityState.Modified;
            _context.SaveChanges();
        }

        public async Task<List<Offer>> GetAllAsync()
        {
            return await _context.Offers.Include(x => x.Reviews).Take(500).ToListAsync(); //??? .Include(x => x.Owner).
        }

        public async Task<List<Offer>> SearchAsync(string input, string town)
        {
            return await _context.Offers.Where(x => x.Title.ToLower().Contains(input.ToLower())).OrderBy(x => x.Town == town).ToListAsync();
        }

        public async Task<List<Offer>> SearchWithCategoryAsync(string town, string category)
        {
            return await _context.Offers.Where(x => x.Stock.OfferType.Category == category).OrderBy(x => x.Town == town).ToListAsync();
        }

        public async Task<Offer> GetByIdAsync(int id)
        {
            return await _context.Offers.Include(x => x.Owner).SingleAsync(x => x.Id == id);  
        }

        public async Task RemoveByIdAsync(int id)
        {
            var offer = await _context.Offers.SingleAsync(x => x.Id == id);
            _context.Offers.Remove(offer);

            await _context.SaveChangesAsync();
        }

        public async Task<Offer?> SingleAsync(int id)
        {
            Offer? offer = await _context.Offers.SingleOrDefaultAsync(x => x.Id == id);
            if (offer != null) return offer;
            else return null;
        }
    }
}
