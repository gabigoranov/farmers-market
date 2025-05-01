using MarketAPI.Data.Models;
using MarketAPI.Migrations;
using MarketAPI.Models;

namespace MarketAPI.Services.Advertise
{
    public interface IAdvertiseService
    {
        public Task Create(AddAdvertiseSettingsViewModel model);
        public decimal CalculatePrice(AddAdvertiseSettingsViewModel model);
        public DateTime CalculateNextPaymentDue(AddAdvertiseSettingsViewModel model);
        public Task<List<Offer>> UpdateRelatedOffers(AdvertiseSettings model, List<int> ids);
    }
}
