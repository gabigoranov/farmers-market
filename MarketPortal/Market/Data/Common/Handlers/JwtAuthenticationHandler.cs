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
using Market.Services.AuthRefresh;

namespace Market.Data.Common.Handlers
{
    public class JwtAuthenticationHandler : DelegatingHandler
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IAuthService _authService;
        private readonly IAuthRefreshService _authRefreshService;
        private readonly HttpClient _client;

        public JwtAuthenticationHandler(IHttpContextAccessor httpContextAccessor, HttpClient client, IAuthService authService, IAuthRefreshService authRefreshService)
        {
            _httpContextAccessor = httpContextAccessor;
            _client = client;
            _authService = authService;
            _authRefreshService = authRefreshService;
        }

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            // Try to get user data from session
            string? userJson = _httpContextAccessor.HttpContext?.Session.GetString("UserData");

            if (userJson != null)
            {
                User user = JsonConvert.DeserializeObject<User>(userJson)!;

                if (user?.Token?.AccessToken != null)
                {
                    // Set the Authorization header with the access token
                    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", user.Token.AccessToken);
                }
            }
            else
            {
                //use JWT cookie to reload user data and session
                User? user = await _authRefreshService.TryRefreshUserData();
                if (user != null && user?.Token?.AccessToken != null)
                {
                    // Set the Authorization header with the access token
                    request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", user.Token!.AccessToken);
                }
            }

            // Send the request
            var response = await base.SendAsync(request, cancellationToken);

            // Handle 401 Unauthorized responses and refresh token if necessary
            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                // Token refresh logic
                string? userJsonForRefresh = _httpContextAccessor.HttpContext?.Session.GetString("UserData");
                if (userJsonForRefresh == null)
                {
                    throw new UnauthorizedAccessException("Please login again.");
                }

                User user = JsonConvert.DeserializeObject<User>(userJsonForRefresh)!;
                User? refreshedUser = await _authRefreshService.TryRefreshToken(user.Token!.RefreshToken);

                if (refreshedUser == null)
                    throw new UnauthorizedAccessException("Please login again.");

                // Update the Authorization header with the new access token
                request.Headers.Authorization = new AuthenticationHeaderValue("Bearer", refreshedUser.Token!.AccessToken);

                // Retry the request with the new token
                response = await base.SendAsync(request, cancellationToken);
            }

            return response;
        }
    }
}
