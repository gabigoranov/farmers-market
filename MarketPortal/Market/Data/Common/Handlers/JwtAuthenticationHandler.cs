using System.Net.Http.Headers;
using System.Net;
using Market.Services;
using Market.Data.Models;
using Market.Models;
using Market.Services.Authentication;
using NuGet.Protocol;

namespace Market.Data.Common.Handlers
{
    public class JwtAuthenticationHandler : DelegatingHandler
    {
        private readonly IHttpContextAccessor _httpContextAccessor;
        private readonly IUserService _userService;
        private readonly IAuthenticationService _authService;

        public JwtAuthenticationHandler(IHttpContextAccessor httpContextAccessor, IUserService userService, IAuthenticationService authService)
        {
            _httpContextAccessor = httpContextAccessor;
            _userService = userService;
            _authService = authService;
        }

        protected override async Task<HttpResponseMessage> SendAsync(
            HttpRequestMessage request,
            CancellationToken cancellationToken)
        {
            // Get token from cookie
            string? jwtToken = null;

            if (string.IsNullOrEmpty(jwtToken))
            {
                User user = _userService.GetUser();
                AuthModel model = new AuthModel(user.Email, user.Password);
                jwtToken = await _authService.GetAuthToken(model);
            }
            request.Headers.Authorization =
                    new AuthenticationHeaderValue("Bearer", jwtToken);

        // Send the request
        var response = await base.SendAsync(request, cancellationToken);

            // Optional: Handle 401 Unauthorized responses
            // You could automatically refresh the token here
            if (response.StatusCode == HttpStatusCode.Unauthorized)
            {
                // You could add token refresh logic here
                // var refreshToken = _httpContextAccessor.HttpContext?.Request.Cookies["RefreshToken"];
                // Implement refresh token logic if needed
            }

            return response;
        }
    }
}
