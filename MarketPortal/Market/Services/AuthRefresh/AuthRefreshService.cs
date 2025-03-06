using Market.Data.Models;
using Market.Services.Authentication;
using Newtonsoft.Json;
using System.Net;
using System.Net.Http.Headers;

namespace Market.Services.AuthRefresh
{
    public class AuthRefreshService : IAuthRefreshService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IAuthService _authService;
        private readonly HttpClient _client;

        public AuthRefreshService(IHttpContextAccessor httpContextAccessor, IAuthService authService, HttpClient client)
        {
            _httpContextAccessor = httpContextAccessor;
            _authService = authService;
            _client = client;
        }

        public async Task<User?> TryRefreshToken(string refreshToken)
        {
            string url = $"https://api.freshly-groceries.com/api/auth/refresh";
            var res = await _client.PostAsJsonAsync(url, refreshToken);
            var content = await res.Content.ReadAsStringAsync();
            if (res == null || res.StatusCode == HttpStatusCode.Unauthorized || content == null)
            {
                await _authService.Logout();
                return null;
            }

            User? response = JsonConvert.DeserializeObject<User?>(content)!;
            // Re-sign in the refreshed user and store the new data in session
            if (response != null)
                await _authService.SignInAsync(response, response.Discriminator == 1 ? "Seller" : "Organization");

            return response;
        }

        public async Task<User?> TryRefreshUserData()
        {
            //use JWT cookie to reload user data and session
            var claimsPrincipal = _httpContextAccessor.HttpContext?.User;
            string? JWTcookie = claimsPrincipal?.FindFirst("JWT")?.Value;
            if (JWTcookie != null)
            {
                //refresh user data
                Token token = JsonConvert.DeserializeObject<Token>(JWTcookie)!;
                User? user = await TryRefreshToken(token.RefreshToken);
                return user;
                
            }
            return null;
        }
    }
}
