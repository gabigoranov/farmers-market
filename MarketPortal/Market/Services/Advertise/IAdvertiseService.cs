using Market.Models;

namespace Market.Services.Advertise
{
    public interface IAdvertiseService
    {
        public Task Create(AddAdvertiseSettingsViewModel model);
    }
}
