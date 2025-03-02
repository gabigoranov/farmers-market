using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Services.Billing
{
    public interface IBillingService
    {
        public Task<int> CreateAsync(BillingDetails model);
        public Task<BillingDetailsDTO> GetAsync(int id);
        public Task DeleteAsync(int id);
        public Task EditAsync(int id, BillingDetails model);
    }
}
