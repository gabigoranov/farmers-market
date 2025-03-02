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
    /// <summary>
    /// Provides endpoints for managing Firebase tokens for users.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class FirebaseController : ControllerBase
    {
        private readonly ApiContext _context;

        /// <summary>
        /// Initializes a new instance of the <see cref="FirebaseController"/> class.
        /// </summary>
        /// <param name="context">The database context.</param>
        public FirebaseController(ApiContext context)
        {
            _context = context;
        }

        /// <summary>
        /// Sets or updates the Firebase token for a specific user.
        /// </summary>
        /// <param name="id">The unique identifier of the user.</param>
        /// <param name="token">The Firebase token to associate with the user.</param>
        /// <returns>
        /// A response indicating whether the operation was successful:
        /// - <c>200 OK</c>: If the token was successfully updated.
        /// - <c>400 Bad Request</c>: If the token is null or empty.
        /// - <c>404 Not Found</c>: If the user does not exist.
        /// </returns>
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
