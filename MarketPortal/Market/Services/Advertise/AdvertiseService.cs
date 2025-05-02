using Market.Data.Common.Handlers;
using Market.Models;
using Market.Services.Authentication;
using Newtonsoft.Json;

namespace Market.Services.Advertise
{
    public class AdvertiseService : IAdvertiseService
    {
        private readonly APIClient _client;
        private readonly IUserService _userService;
        private readonly IAuthService _authService;
        private const string BASE_URL = "https://api.freshly-groceries.com/api/advertise/";
        public AdvertiseService(APIClient client, IUserService userService, IAuthService authService)
        {
            this._client = client;
            _userService = userService;
            _authService = authService;
        }

        public async Task Create(AddAdvertiseSettingsViewModel model)
        {
            model.SellerId = _userService.GetUser().Id;
            await _client.PostAsync<string>(BASE_URL, model);
        }
    }
}
