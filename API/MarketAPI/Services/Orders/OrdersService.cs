using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Orders
{
    public class OrdersService : IOrdersService
    {
        private readonly ApiContext _context;
        private readonly IMapper _mapper;

        public OrdersService(ApiContext apiContext, IMapper mapper)
        {
            this._context = apiContext;
            _mapper = mapper;
        }
        public async Task<Order> CreateOrderAsync(OrderViewModel model, int billingDetailsId)
        {
            Order result = _mapper.Map<Order>(model);
            result.Buyer = await _context.Users.FirstAsync(x => x.Id == model.BuyerId);
            result.Seller = await _context.Sellers.FirstAsync(x => x.Id == model.SellerId);
            result.Offer = await _context.Offers.FirstAsync(x => x.Id == model.OfferId);
            result.BillingDetailsId = billingDetailsId;
            
            await _context.Orders.AddAsync(result);
            _context.Stocks.First(x => x.Id == result.Offer.StockId).Quantity -= result.Quantity;
            await _context.SaveChangesAsync();
            return result;
        }


        public async Task<List<Order>> CreateOrdersAsync(ICollection<OrderViewModel> orders, int billingDetailsId)
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

        public List<OrderDTO> GetAllOrders()
        {
            var res = _context.Orders.Include(x => x.Offer).ToList();
            return _mapper.Map<List<OrderDTO>>(res);
        }

        public async Task<OrderDTO> GetOrderAsync(int id)
        {
            Order? order = await _context.Orders
                                    .AsNoTracking()
                                    .Include(x => x.BillingDetails)
                                    .Include(x => x.Offer)
                                    .Include(x => x.Buyer)
                                    .FirstOrDefaultAsync(x => x.Id==id);
            if(order == null)
                throw new ArgumentNullException(nameof(order), "Order with specified id does not exist.");

            return _mapper.Map<OrderDTO>(order);

        }

        public IEnumerable<OrderDTO>? GetSellerOrders(Guid id)
        {
            if (!_context.Users.Any(x => x.Id == id))
                return null;

            var res = _context.Orders.AsNoTracking().Include(x => x.BillingDetails).Include(x => x.Offer).Include(x => x.Buyer).Where(x => x.SellerId == id);

            return _mapper.Map<IEnumerable<OrderDTO>?>(res);
        }
    }
}
