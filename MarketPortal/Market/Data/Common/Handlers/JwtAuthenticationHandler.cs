using System.Net.Http.Headers;
using System.Net;
using Market.Services;
using Market.Data.Models;
using Market.Models;
using Market.Services.Authentication;
using NuGet.Protocol;
using Newtonsoft.Json;
using System.Security.Claims;
using Microsoft.AspNetCore.Http;
using System.Net.Http;
using Microsoft.AspNetCore.Mvc;
using Azure.Core;

namespace Market.Data.Common.Handlers
{
    public class JwtAuthenticationHandler : DelegatingHandler
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IAuthService _authService;
        private readonly HttpClient _client;

        public JwtAuthenticationHandler(IHttpContextAccessor httpContextAccessor, HttpClient client, IAuthService authService)
        {
            _httpContextAccessor = httpContextAccessor;
            _client = client;
            _authService = authService;
        }

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            // Try to get token from cookie
            string? cookie = _httpContextAccessor.HttpContext?.User.Claims.FirstOrDefault(x => x.Type == ClaimTypes.UserData)?.Value;
            if (cookie != null)
            {
                User user = JsonConvert.DeserializeObject<User>(cookie)!;
                request.Headers.Authorization =
                        new AuthenticationHeaderValue("Bearer", user!.Token!.AccessToken);
            }

            // Send the request
            var response = await base.SendAsync(request, cancellationToken);

            // Handle 401 Unauthorized responses and refresh token if necessary
            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                // You could add logic to refresh the token here

                User user = JsonConvert.DeserializeObject<User>(cookie)!;
                var res = await TryRefreshToken(user.Token.RefreshToken);
                if (res == null)
                    throw new UnauthorizedAccessException("Please login again.");
                user = res;
                await _authService.SignInAsync(user, user.Discriminator == 1 ? "Seller" : "Organization");

                if (res != null)
                {
                    request.Headers.Authorization =
                        new AuthenticationHeaderValue("Bearer", user.Token.AccessToken);
                    response = await base.SendAsync(request, cancellationToken);
                }
            }

            return response;
        }

        private async Task<User?> TryRefreshToken(string token)
        {
            string url = $"https://api.freshly-groceries.com/api/auth/refresh";
            var res = await _client.PostAsJsonAsync(url, token);

            if (res == null || res.StatusCode == HttpStatusCode.Unauthorized)
            {
                await _authService.Logout();
                return null;
            }

            User response = JsonConvert.DeserializeObject<User>(await res.Content.ReadAsStringAsync())!;
            
            return response;
        }
    }
}
