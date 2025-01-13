using MarketAPI.Data.Models;
using MarketAPI.Models;

namespace MarketAPI.Services.Inventory
{
    public interface IInventoryService
    {
        public Task CreateStockAsync(StockViewModel model);
        public List<Stock> GetUserStocksAsync(Guid id);
        public Task IncreaseQuantityAsync(int id, double quantity);
        public Task DecreaseQuantityAsync(int id, double quantity);
        public Task DeleteAsync(int id);
        public Task<Stock> GetStockAsync(int id);
    }
}