using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Auth;
using MarketAPI.Services.Users;
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
        private readonly IAuthService _authService;

        public AuthController(ApiContext context, IUsersService userService, IAuthService authService)
        {
            _context = context;
            _userService = userService;
            _authService = authService;
        }

        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] AuthModel model)
        {
            if(!ModelState.IsValid) 
                return BadRequest(ModelState);

            User? user = await _userService.LoginAsync(model);
            if (user == null) return NotFound("User does not exist.");

            return NotFound("User does not exist.");
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

        [HttpPost("token")]
        public async Task<IActionResult> GenerateToken([FromBody] AuthModel login)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);

            if (await _userService.UserExistsAsync(login))
            {
                return Ok(_authService.CreateNewToken(login));
            }

            return BadRequest("Specified user does not exist.");
        }
    }
}
