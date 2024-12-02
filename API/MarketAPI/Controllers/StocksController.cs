using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Offers;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    public class StocksController : ControllerBase
    {
        private readonly ApiContext _context;
        public StocksController(ApiContext _context)
        {
            this._context = _context;
        }

        [Route("add")]
        [HttpPost]
        public async Task<IActionResult> Add([FromBody] StockViewModel model)
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
            return Ok("Stock added succesfully");
        }

        [Route("get")]
        [HttpGet]
        public async Task<IActionResult> GetUserStocks(Guid sellerId)
        {
            List<Stock> stocks = _context.Stocks.Where(x => x.SellerId == sellerId).ToList();
            return Ok(stocks);
        }

        [Route("up")]
        [HttpGet]
        public async Task<IActionResult> Up(int id, double quantity)
        {
            _context.Stocks.First(x => x.Id ==id).Quantity += quantity;
            await _context.SaveChangesAsync();
            return Ok("Stock increased succesfully");
        }

        [Route("down")]
        [HttpGet]
        public async Task<IActionResult> Down(int id, double quantity)
        {
            var stock = _context.Stocks.First(x => x.Id == id);
            _context.Update(stock);
            stock.Quantity -= quantity;
            if (stock.Quantity < 0) stock.Quantity = 0;
            await _context.SaveChangesAsync();
            return Ok("Stock decreased succesfully");
        }

        [Route("delete")]
        [HttpDelete]
        public async Task<IActionResult> Delete(int stockId)
        {
            _context.Offers.RemoveRange(_context.Offers.Where(x => x.StockId == stockId).ToList()); 
            _context.Stocks.Remove(_context.Stocks.First(x => x.Id == stockId));
            await _context.SaveChangesAsync();
            return Ok("Stock deleted succesfully");
        }
    }
}
