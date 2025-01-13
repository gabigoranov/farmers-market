using Market.Data.Models;
using Market.Models;

namespace Market.Services.Billing
{
    public interface IBillingService
    {
        public Task CreateBillingDetailsAsync(BillingDetailsViewModel model);
        public Task EditBillingDetailsAsync(BillingDetails model);
        public Task DeleteBillingDetailsAsync(int id);
        public BillingDetails? GetById(int id);

    }
}
