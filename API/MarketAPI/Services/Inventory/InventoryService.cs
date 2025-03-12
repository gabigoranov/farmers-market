using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Inventory
{
    public class InventoryService : IInventoryService
    {
        private readonly ApiContext _context;
        private readonly IMapper _mapper;
        public InventoryService(ApiContext context, IMapper mapper)
        {
            _context = context;
            _mapper = mapper;
        }

        public async Task CreateStockAsync(StockViewModel model)
        {
            Stock stock = new Stock()
            {
                Title = model.Title,
                Quantity = model.Quantity,
                OfferTypeId = model.OfferTypeId,
                SellerId = model.SellerId,
            };
            await _context.Stocks.AddAsync(stock);
            await _context.SaveChangesAsync();
        }

        public async Task DecreaseQuantityAsync(int id, decimal quantity)
        {
            if (quantity <= 0) return;
            Stock? stock = await _context.Stocks.FirstOrDefaultAsync(x => x.Id == id);
            if (stock == null) throw new ArgumentNullException(nameof(stock), "Stock with specified id does not exist.");
            _context.Update(stock);
            stock!.Quantity -= quantity;
            if (stock.Quantity < 0) stock.Quantity = 0;
            await _context.SaveChangesAsync();
        }

        public async Task DeleteAsync(int id)
        {
            //TODO: make removing offers automatic
            _context.Offers.RemoveRange(_context.Offers.Where(x => x.StockId == id));
            _context.Stocks.Remove(_context.Stocks.First(x => x.Id == id));
            await _context.SaveChangesAsync();
        }

        public async Task<StockDTO> GetStockAsync(int id)
        {
            Stock? stock = await _context.Stocks.SingleOrDefaultAsync(x => x.Id == id);
            if (stock == null) throw new ArgumentNullException(nameof(stock), "Stock with specified id does not exist.");
            return _mapper.Map<StockDTO>(stock);
        }

        public List<StockDTO> GetUserStocksAsync(Guid id)
        {
            var res = _context.Stocks.Where(x => x.SellerId == id).ToList();
            return _mapper.Map<List<StockDTO>>(res);  
        }

        public async Task IncreaseQuantityAsync(int id, decimal quantity)
        {
            if (quantity <= 0) return;
            var stock = await _context.Stocks.FirstOrDefaultAsync(x => x.Id == id);
            if (stock == null) throw new ArgumentNullException(nameof(stock), "Stock with specified id does not exist.");
            _context.Update(stock);
            stock.Quantity += quantity;
            await _context.SaveChangesAsync();
        }
    }
}
