using MarketAPI.Data.Models;
using MarketAPI.Models;

namespace MarketAPI.Services.Purchases
{
    public interface IPurchaseService
    {
        public Task CreatePurchaseAsync(PurchaseViewModel model);
        public List<Purchase> GetAllPurchasesAsync();
    }
}
