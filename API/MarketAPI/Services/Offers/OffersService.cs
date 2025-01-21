using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Offers;
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using Microsoft.IdentityModel.Tokens;
using System;
using System.Collections.Generic;
using System.Net;

namespace MarketAPI.Services.Offers
{
    public class OffersService : IOffersService
    {
        private readonly ApiContext _context;
        private readonly IMapper _mapper;

        public OffersService(ApiContext apiContext, IMapper mapper)
        {
            this._context = apiContext;
            _mapper = mapper;
        }

        public async Task<int> CreateOfferAsync(OfferViewModel model)
        {
            Offer offer = _mapper.Map<Offer>(model);

            await _context.AddAsync(offer);
            await _context.SaveChangesAsync();

            return offer.Id;

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

        public List<OfferDTO> GetAll()
        {
            var res = _context.Offers.Include(x => x.Reviews).Take(500).ToList();
            return _mapper.Map<List<OfferDTO>>(res);
        }

        public async Task<List<OfferDTO>> SearchAsync(string input, string town)
        {
            var res = await _context.Offers.Where(x => x.Title.ToLower().Contains(input.ToLower())).OrderBy(x => x.Town == town).ToListAsync();
            return _mapper.Map<List<OfferDTO>>(res);
        }

        public async Task<List<OfferDTO>> SearchWithCategoryAsync(string town, string category)
        {
            var res = await _context.Offers.Where(x => x.Stock.OfferType.Category == category).OrderBy(x => x.Town == town).ToListAsync();
            return _mapper.Map<List<OfferDTO>>(res);
        }

        public async Task<OfferDTO> GetByIdAsync(int id)
        {
            var res = await _context.Offers.Include(x => x.Owner).SingleAsync(x => x.Id == id);
            return _mapper.Map<OfferDTO>(res);
        }

        public async Task DeleteAsync(int id)
        {
            var offer = await _context.Offers.SingleOrDefaultAsync(x => x.Id == id);
            if(offer == null)
                throw new ArgumentNullException(nameof(offer), "Offer with id does not exist.");
            _context.Offers.Remove(offer);
            await _context.SaveChangesAsync();
        }

        public async Task<OfferDTO?> GetOfferAsync(int id)
        {
            Offer? offer = await _context.Offers.Include(x => x.Stock).ThenInclude(x => x.OfferType).SingleOrDefaultAsync(x => x.Id == id);
            if (offer != null) return _mapper.Map<OfferDTO>(offer);
            else return null;
        }

        public async Task CreateOfferTypeAsync(OfferType offerType)
        {
            await _context.OfferTypes.AddAsync(offerType);
            await _context.SaveChangesAsync();
        }

        public IEnumerable<OfferWithUnitsSoldDTO>? GetSellerOffers(Guid id)
        {
            IEnumerable<Offer> offers = _context.Offers.AsNoTracking().Include(x => x.Orders).Where(x => x.OwnerId == id);
            if (offers.IsNullOrEmpty()) return null;
            IEnumerable<OfferWithUnitsSoldDTO> res = _mapper.Map<IEnumerable<OfferWithUnitsSoldDTO>>(offers);

            return res;
        }

        public async Task<List<OfferType>> GetAllOfferTypes()
        {
            List<OfferType> offerTypes = await _context.OfferTypes.AsNoTracking().ToListAsync();
            return offerTypes;
        }
    }
}
