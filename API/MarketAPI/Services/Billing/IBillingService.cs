using MarketAPI.Data.Models;

namespace MarketAPI.Services.Billing
{
    public interface IBillingService
    {
        public Task<int> CreateAsync(BillingDetails model);
        public Task<BillingDetails> GetAsync(int id);
        public Task DeleteAsync(int id);
        public Task EditAsync(int id, BillingDetails model);
    }
}
