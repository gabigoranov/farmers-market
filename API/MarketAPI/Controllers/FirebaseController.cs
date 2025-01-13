using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Identity;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using System;
using System.Reflection.Metadata.Ecma335;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class FirebaseController : ControllerBase
    {
        private readonly ApiContext _context;

        public FirebaseController(ApiContext context)
        {
            _context = context;
        }

        [HttpPost("token/{id}")]
        public async Task<IActionResult> SetFirebaseToken([FromRoute] Guid id, [FromBody] string token)
        {

            if (string.IsNullOrWhiteSpace(token))
            {
                return BadRequest("Firebase token cannot be null or empty.");
            }
 
            var user = await _context.Users.SingleOrDefaultAsync(x => x.Id == id);
            if (user == null)
            {
                return NotFound("User not found.");
            }

            _context.Users.Update(user);
            user.FirebaseToken = token;
            await _context.SaveChangesAsync();

            return Ok("Firebase token updated successfully.");
        }

    }
}
