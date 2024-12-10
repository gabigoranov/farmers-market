using Market.Data.Models;

namespace Market.Models
{
    public class JWTRefreshResponse
    {
        public JWTRefreshResponse(Token refreshToken, string accessToken)
        {
            RefreshToken = refreshToken;
            AccessToken = accessToken;
        }

        public Token RefreshToken { get; set; }
        public string AccessToken { get; set; }
    }
}
