﻿using MarketAPI.Data;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Security.Cryptography;
using System.Text;

namespace MarketAPI.Services.Token
{
    public class TokenService
    {
        private readonly IConfiguration _configuration;
        private readonly ApiContext _context;

        public TokenService(IConfiguration configuration, ApiContext context)
        {
            _configuration = configuration;
            _context = context;
        }

        public string GenerateAccessToken(IEnumerable<Claim> claims)
        {
            var jwtSettings = _configuration.GetSection("Jwt");
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Key"]));
            var credentials = new SigningCredentials(key, SecurityAlgorithms.HmacSha256);

            var token = new JwtSecurityToken(
                issuer: jwtSettings["Issuer"],
                audience: jwtSettings["Audience"],
                claims: claims,
                expires: DateTime.UtcNow.AddMinutes(int.Parse(jwtSettings["AccessTokenExpirationMinutes"])),
                signingCredentials: credentials
            );

            return new JwtSecurityTokenHandler().WriteToken(token);
        }

        public string GenerateRefreshToken()
        {
            var randomNumber = new byte[32];
            using var rng = RandomNumberGenerator.Create();
            rng.GetBytes(randomNumber);
            return Convert.ToBase64String(randomNumber);
        }

        public ClaimsPrincipal? GetPrincipalFromExpiredToken(string token)
        {
            var jwtSettings = _configuration.GetSection("Jwt");
            var tokenHandler = new JwtSecurityTokenHandler();
            var key = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings["Key"]));

            try
            {
                var principal = tokenHandler.ValidateToken(token, new TokenValidationParameters
                {
                    ValidateIssuerSigningKey = true,
                    IssuerSigningKey = key,
                    ValidateIssuer = true,
                    ValidIssuer = jwtSettings["Issuer"],
                    ValidateAudience = true,
                    ValidAudience = jwtSettings["Audience"],
                    ValidateLifetime = false // We only want to validate signature, not expiration
                }, out _);

                return principal;
            }
            catch
            {
                return null;
            }
        }

        public async Task<Data.Models.Token> CreateTokenAsync(Guid userId)
        {
            string token = GenerateRefreshToken();
            Data.Models.Token res = new Data.Models.Token()
            {
                UserId = userId,
                RefreshToken = token,
                ExpiryDateTime = DateTime.UtcNow.AddDays(30),
            };
            Data.Models.Token? old = await _context.Tokens.SingleOrDefaultAsync(x => x.UserId == userId);
            if(old != null) _context.Tokens.Remove(old);
            await _context.Tokens.AddAsync(res);
            await _context.SaveChangesAsync();
            return res;
        }
    }
}