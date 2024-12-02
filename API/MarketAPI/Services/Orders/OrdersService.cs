using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Orders
{
    public class OrdersService : IOrdersService
    {
        private readonly ApiContext _context;

        public OrdersService(ApiContext apiContext)
        {
            this._context = apiContext;
        }
        public async Task<Order> AddOrderAsync(OrderViewModel model)
        {
            Order result = new Order()
            {
                Buyer = await _context.Users.FirstAsync(x => x.Id == model.BuyerId),
                BuyerId = model.BuyerId,
                Seller = await _context.Sellers.FirstAsync(x => x.Id == model.SellerId),
                SellerId = model.SellerId,
                Price = model.Price,
                OfferId = model.OfferId,
                Offer = await _context.Offers.FirstAsync(x => x.Id == model.OfferId),
                Quantity = model.Quantity,
                DateOrdered = DateTime.Now,
                IsDelivered = false,
                Address = model.Address,
                IsAccepted = false,
                Title = model.Title,
            };

            await _context.Orders.AddAsync(result);
            _context.Stocks.First(x => x.Id == result.Offer.StockId).Quantity -= result.Quantity;
            await _context.SaveChangesAsync();
            return result;
        }


        public async Task<ICollection<Order>> AddOrdersAsync(ICollection<OrderViewModel> orders)
        {
            List<Order> result = new List<Order>();
            foreach(var order in orders)
            {
                result.Add(await AddOrderAsync(order));
            }
            return result;
        }

    }
}
