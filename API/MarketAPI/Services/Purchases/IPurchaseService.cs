using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Purchases
{
    public interface IPurchaseService
    {
        public Task<Purchase> CreatePurchaseAsync(PurchaseViewModel model);
        public List<PurchaseDTO> GetAllPurchasesAsync();
    }
}
