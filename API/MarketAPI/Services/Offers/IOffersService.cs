using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Offers
{
    public interface IOffersService
    {
        public List<OfferDTO> GetAll();
        public Task<int> CreateOfferAsync(OfferViewModel offer);
        public Task<OfferDTO> GetByIdAsync(int id);
        public Task DeleteAsync(int id);
        public Task<List<OfferDTO>> SearchAsync(string input, string town);
        public Task<List<OfferDTO>> SearchWithCategoryAsync(string town, string category);
        public Task EditAsync(OfferViewModel offerEdit);
        public Task<OfferDTO?> GetOfferAsync(int id);
        public Task CreateOfferTypeAsync(OfferType offerType);
        public IEnumerable<OfferWithUnitsSoldDTO>? GetSellerOffers(Guid id);
        Task<List<OfferType>> GetAllOfferTypes();
    }
}
