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

        [HttpGet("refresh/{id}")]
        public async Task<IActionResult> Refresh(Guid id)
        {
            User? user = await _userService.GetUserAsync(id);
            if (user == null) return NotFound("User does not exist.");
            if (user.Token == null)
                return Unauthorized("User has not logged in");

            _context.Update(user);

            var accessToken = _tokenService.GenerateAccessToken(new[]{
                new Claim(ClaimTypes.Email, user.Email),
                new Claim(ClaimTypes.Role, "User")
            });


            
            user!.Token.ExpiryDateTime = DateTime.UtcNow.AddDays(30); //does this update db
            await _context.SaveChangesAsync();
            //await _userService.UpdateUserTokensAsync(refreshToken, user.Id);

            return Ok(new JWTRefreshResponse(user.Token, accessToken));
        }

        
    }
}
