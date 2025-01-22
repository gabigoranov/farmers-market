using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
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
    /// <summary>
    /// Provides endpoints for authentication-related actions such as login, registration, and token refresh.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ApiContext _context;
        private readonly IUsersService _userService;
        private readonly TokenService _tokenService;

        /// <summary>
        /// Initializes a new instance of the <see cref="AuthController"/> class.
        /// </summary>
        /// <param name="context">The application database context.</param>
        /// <param name="userService">Service for managing user operations.</param>
        /// <param name="tokenService">Service for handling token generation and management.</param>
        public AuthController(ApiContext context, IUsersService userService, TokenService tokenService)
        {
            _context = context;
            _userService = userService;
            _tokenService = tokenService;
        }

        /// <summary>
        /// Authenticates a user and provides access tokens upon successful login.
        /// </summary>
        /// <param name="model">The user authentication details.</param>
        /// <returns>
        /// A response containing the authenticated user's details and tokens, or an error message if authentication fails.
        /// </returns>
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] AuthModel model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            UserDTO? user = await _userService.LoginAsync(model);
            if (user == null) return NotFound("User does not exist.");

            await _context.SaveChangesAsync();
            return Ok(user);
        }

        /// <summary>
        /// Registers a new user in the system.
        /// </summary>
        /// <param name="user">The details of the user to be created.</param>
        /// <returns>
        /// A success message if registration is successful, or an error message if validation fails.
        /// </returns>
        [HttpPost("register")]
        public async Task<IActionResult> Create([FromBody] AddUserViewModel user)
        {
            if (!ModelState.IsValid)
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

        /// <summary>
        /// Refreshes the access token using a valid refresh token.
        /// </summary>
        /// <param name="refreshToken">The refresh token to validate and use for generating a new access token.</param>
        /// <returns>
        /// A response containing the updated access token and its expiry, or an error message if the refresh token is invalid or expired.
        /// </returns>
        [HttpPost("refresh")]
        public async Task<IActionResult> Refresh([FromBody] string refreshToken)
        {
            if (string.IsNullOrEmpty(refreshToken))
                return BadRequest("Refresh token is required.");

            var tokenEntity = await _context.Tokens.Include(t => t.User)
                                                   .FirstOrDefaultAsync(t => t.RefreshToken == refreshToken);

            if (tokenEntity == null || tokenEntity.User == null)
                return Unauthorized("Invalid refresh token.");

            if (tokenEntity.ExpiryDateTime < DateTime.UtcNow)
                return Unauthorized("Refresh token has expired.");

            var user = await _userService.GetUserAsync(tokenEntity.UserId);
            if (user == null)
                return Unauthorized("User with specified id does not exist.");

            user!.Token!.AccessToken = _tokenService.GenerateAccessToken(new[]
            {
                new Claim(ClaimTypes.NameIdentifier, user.Id.ToString()),
                new Claim(ClaimTypes.Role, user.Discriminator == 0 ? "User" : user.Discriminator == 1 ? "Seller" : "Organization")
            });

            user.Token.ExpiryDateTime = DateTime.UtcNow.AddDays(30);

            await _context.SaveChangesAsync();

            return Ok(user);
        }
    }
}
