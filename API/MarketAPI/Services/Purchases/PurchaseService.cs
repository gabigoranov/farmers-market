using AutoMapper;
using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Orders;
using Microsoft.EntityFrameworkCore;

namespace MarketAPI.Services.Purchases
{
    public class PurchaseService : IPurchaseService
    {
        private readonly IOrdersService _ordersService;
        private readonly ApiContext _context;
        private readonly IMapper _mapper;


        public PurchaseService(IOrdersService ordersService, ApiContext context, IMapper mapper)
        {
            _ordersService = ordersService;
            _context = context;
            _mapper = mapper;
        }
        public async Task<Purchase> CreatePurchaseAsync(PurchaseViewModel model)
        {
            if (!_context.Users.Any(x => x.Id == model.BuyerId))
                throw new ArgumentNullException(nameof(User), "Buyer with specified id does not exist.");


            Purchase purchase = _mapper.Map<Purchase>(model);

            purchase.DateOrdered = DateTime.UtcNow;
            purchase.Orders = await _ordersService.CreateOrdersAsync(model.Orders, model.BillingDetailsId);

            await _context.Purchases.AddAsync(purchase);
            await _context.SaveChangesAsync();

            return purchase;
        }

        public List<PurchaseDTO> GetAllPurchasesAsync()
        {
            var res = _context.Purchases.Include(x => x.Orders).ToList();
            return _mapper.Map<List<PurchaseDTO>>(res);
        }
    }
}
