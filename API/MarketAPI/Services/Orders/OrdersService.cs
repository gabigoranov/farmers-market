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
        public async Task<Order> CreateOrderAsync(OrderViewModel model, int billingDetailsId)
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
                BillingDetailsId = billingDetailsId,
            };

            await _context.Orders.AddAsync(result);
            _context.Stocks.First(x => x.Id == result.Offer.StockId).Quantity -= result.Quantity;
            await _context.SaveChangesAsync();
            return result;
        }


        public async Task<ICollection<Order>> CreateOrdersAsync(ICollection<OrderViewModel> orders, int billingDetailsId)
        {
            List<Order> result = new List<Order>();
            foreach(var order in orders)
            {
                result.Add(await CreateOrderAsync(order, billingDetailsId));
            }
            return result;
        }

        public async Task<string> ApproveOrderAsync(int id)
        {
            Order? order = await _context.Orders.Include(x => x.Offer).Include(x => x.Buyer).FirstOrDefaultAsync(x => x.Id == id);
            if (order == null)
                throw new ArgumentNullException(nameof(order), "Order with specified id does not exist.");

            _context.Update(order);
            order.IsAccepted = true;
            Stock? stock = await _context.Stocks.SingleOrDefaultAsync(x => x.Id == order.Offer.StockId);
            if (stock == null)
                throw new ArgumentNullException(nameof(order), "Stock with specified id does not exist.");

            _context.Update(stock);
            stock.Quantity -= order.Quantity;
            await _context.SaveChangesAsync();

            return order.Buyer.FirebaseToken!;
        }

        public async Task<string> DeclineOrderAsync(int id)
        {
            Order? order = await _context.Orders.Include(x => x.Offer).Include(x => x.Buyer).FirstOrDefaultAsync(x => x.Id == id);
            if (order == null)
                throw new ArgumentNullException(nameof(order), "Order with specified id does not exist.");

            _context.Update(order);
            order.IsDenied = true;
            await _context.SaveChangesAsync();

            return order.Buyer.FirebaseToken!;
        }

        public async Task<string> DeliverOrderAsync(int id)
        {
            Order? order = await _context.Orders.Include(x => x.Buyer).SingleOrDefaultAsync(x => x.Id == id);
            if (order == null)
                throw new ArgumentNullException(nameof(order), "Order with specified id does not exist.");
            _context.Update(order);
            order.IsDelivered = true;
            order.DateDelivered = DateTime.Now;
            await _context.SaveChangesAsync();

            return order.Buyer.FirebaseToken!;
        }

        public List<Order> GetAllOrders()
        {
            return _context.Orders.Include(x => x.Offer).ToList();
        }

        public async Task<Order> GetOrderAsync(int id)
        {
            Order? order = await _context.Orders
                                    .AsNoTracking()
                                    .Include(x => x.BillingDetails)
                                    .Include(x => x.Offer)
                                    .Include(x => x.Buyer)
                                    .FirstOrDefaultAsync(x => x.Id==id);
            if(order == null)
                throw new ArgumentNullException(nameof(order), "Order with specified id does not exist.");

            return order;

        }

        public IEnumerable<Order>? GetSellerOrders(Guid id)
        {
            if (!_context.Users.Any(x => x.Id == id))
                return null;
            return _context.Orders.AsNoTracking().Include(x => x.BillingDetails).Include(x => x.Offer).Include(x => x.Buyer).Where(x => x.SellerId == id);
        }
    }
}
