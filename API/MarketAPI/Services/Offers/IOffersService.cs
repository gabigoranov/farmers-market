using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Offers
{
    public interface IOffersService
    {
        public List<Offer> GetAll();
        public Task<int> CreateOfferAsync(OfferViewModel offer);
        public Task<Offer> GetByIdAsync(int id);
        public Task DeleteAsync(int id);
        public Task<List<Offer>> SearchAsync(string input, string town);
        public Task<List<Offer>> SearchWithCategoryAsync(string town, string category);
        public Task EditAsync(OfferViewModel offerEdit);
        public Task<Offer?> GetOfferAsync(int id);
        public Task CreateOfferTypeAsync(OfferType offerType);
        public IEnumerable<OfferWithUnitsSoldDTO>? GetSellerOffers(Guid id);
        Task<List<OfferType>> GetAllOfferTypes();
    }
}
