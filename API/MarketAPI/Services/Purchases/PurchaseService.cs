using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Orders;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Purchases
{
    public class PurchaseService : IPurchaseService
    {
        private readonly IOrdersService _ordersService;
        private readonly ApiContext _context;

        public PurchaseService(IOrdersService ordersService, ApiContext context)
        {
            _ordersService = ordersService;
            _context = context;
        }
        public async Task CreatePurchaseAsync(PurchaseViewModel model)
        {
            if (!_context.Users.Any(x => x.Id == model.BuyerId))
                throw new ArgumentNullException(nameof(User), "Buyer with specified id does not exist.");

            Purchase purchase = new Purchase()
            {
                Address = model.Address,
                IsApproved = false,
                DateOrdered = DateTime.UtcNow,
                BuyerId = model.BuyerId,
                Orders = await _ordersService.CreateOrdersAsync(model.Orders, model.BillingDetailsId),
                Price = model.Price,
                BillingDetailsId = model.BillingDetailsId,
            };

            await _context.Purchases.AddAsync(purchase);
            await _context.SaveChangesAsync();
        }

        public List<Purchase> GetAllPurchasesAsync() => _context.Purchases.Include(x => x.Orders).ToList();
    }
}
