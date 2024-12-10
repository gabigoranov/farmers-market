using System.Net.Http.Headers;
using System.Net;
using Market.Services;
using Market.Data.Models;
using Market.Models;
using Market.Services.Authentication;
using NuGet.Protocol;
using Newtonsoft.Json;
using System.Security.Claims;

namespace Market.Data.Common.Handlers
{
    public class JwtAuthenticationHandler : DelegatingHandler
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly HttpClient _client;

        public JwtAuthenticationHandler(IHttpContextAccessor httpContextAccessor, HttpClient client)
        {
            _httpContextAccessor = httpContextAccessor;
            _client = client;
        }

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            // Try to get token from cookie
            string? cookie = _httpContextAccessor.HttpContext?.Request.Cookies["JWTToken"];
            if (cookie != null)
            {
                string accessToken = JsonConvert.DeserializeObject<string>(cookie)!;
                request.Headers.Authorization =
                        new AuthenticationHeaderValue("Bearer", accessToken);
            }

            // Send the request
            var response = await base.SendAsync(request, cancellationToken);

            // Handle 401 Unauthorized responses and refresh token if necessary
            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                // You could add logic to refresh the token here
                var res = await TryRefreshToken(JsonConvert.DeserializeObject<User>(_httpContextAccessor.HttpContext?.User.Claims.First(x => x.Type == ClaimTypes.UserData).Value).Id);

                if (res != null)
                {
                    // Retry the request with the new token
                    await base.SendAsync(request, cancellationToken);
                }
            }

            return response;
        }

        private async Task<string?> TryRefreshToken(Guid id)
        {
            string url = $"https://farmers-api.runasp.net/api/auth/refresh/{id}";
            var newAccessToken = await _client.GetFromJsonAsync<JWTRefreshResponse>(url);

            if (newAccessToken != null)
            {
                // Store the new access token in the cookie
                _httpContextAccessor.HttpContext?.Response.Cookies.Append("JWTToken", JsonConvert.SerializeObject(newAccessToken.AccessToken), new CookieOptions
                {
                    HttpOnly = true,
                    Secure = true,
                    SameSite = SameSiteMode.Strict,
                });

                // Optionally, store the new refresh token if your system uses a new refresh token for every refresh
                // _httpContextAccessor.HttpContext?.Response.Cookies.Append("RefreshToken", newRefreshToken, new CookieOptions { ... });

                return newAccessToken.AccessToken;
            }

            return null;
        }
    }
}
