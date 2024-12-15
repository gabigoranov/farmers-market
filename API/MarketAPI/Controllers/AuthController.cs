using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Token;
using MarketAPI.Services.Users;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System;
using System.IdentityModel.Tokens.Jwt;
using System.Reflection.Metadata.Ecma335;
using System.Security.Claims;
using System.Text;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ApiContext _context;
        private readonly IUsersService _userService;
        private readonly TokenService _tokenService;

        public AuthController(ApiContext context, IUsersService userService, TokenService tokenService)
        {
            _context = context;
            _userService = userService;
            _tokenService = tokenService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] AuthModel model)
        {
            if(!ModelState.IsValid) 
                return BadRequest(ModelState);

            User? user = await _userService.LoginAsync(model); // todо: include tokens in login
            if (user == null) return NotFound("User does not exist.");
            _context.Update(user);
            user.Token = await _tokenService.CreateTokenAsync(user.Id);
            user.TokenId = user.Token.Id;
            user.Token.AccessToken = _tokenService.GenerateAccessToken(new[]
            {
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, "User")
            });
            await _context.SaveChangesAsync();
            return Ok(user);
        }

        [HttpPost("register")]
        public async Task<IActionResult> Create([FromBody] AddUserViewModel user)
        {
            if(!ModelState.IsValid) 
                return BadRequest(ModelState);

            try
            {
                await _userService.CreateUserAsync(user);
                return Ok("User added successfully");
            }
            catch (InvalidDataException ex)
            {
                return BadRequest(ex.Message);
            }
            
        }

        [HttpPost("refresh")]
        public async Task<IActionResult> Refresh([FromBody] string refreshToken)
        {
            if (string.IsNullOrEmpty(refreshToken))
                return BadRequest("Refresh token is required.");

            // Find the token in the database
            var tokenEntity = await _context.Tokens.Include(t => t.User)
                                                   .FirstOrDefaultAsync(t => t.RefreshToken == refreshToken);

            if (tokenEntity == null || tokenEntity.User == null)
                return Unauthorized("Invalid refresh token.");

            // Check if the refresh token is expired
            if (tokenEntity.ExpiryDateTime < DateTime.UtcNow)
                return Unauthorized("Refresh token has expired.");

            // Generate a new access token
            var user = tokenEntity.User;
            tokenEntity.AccessToken = _tokenService.GenerateAccessToken(new[]
            {
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, "User")
            });

            // Update the refresh token's expiry date
            tokenEntity.ExpiryDateTime = DateTime.UtcNow.AddDays(30);
            await _context.SaveChangesAsync();

            // Return the new tokens
            return Ok(tokenEntity);
        }


    }
}
