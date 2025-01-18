using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Inventory
{
    public interface IInventoryService
    {
        public Task CreateStockAsync(StockViewModel model);
        public List<StockDTO> GetUserStocksAsync(Guid id);
        public Task IncreaseQuantityAsync(int id, double quantity);
        public Task DecreaseQuantityAsync(int id, double quantity);
        public Task DeleteAsync(int id);
        public Task<StockDTO> GetStockAsync(int id);
    }
}