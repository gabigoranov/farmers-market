using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Services.Users;
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
    public class UsersController : ControllerBase
    {
        private readonly IUsersService _usersService;

        public UsersController(IUsersService usersService)
        {
            _usersService = usersService;
        }

        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> Get([FromRoute] Guid id) 
        {
            User? user = await _usersService.GetUserAsync(id);
            if(user == null) return NotFound();
            return Ok(user);
        }

        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> Edit([FromRoute] Guid id, [FromBody] AddUserViewModel model)
        {
            if(!ModelState.IsValid)
                return BadRequest(ModelState);

            try
            {
                await _usersService.EditUserAsync(id, model);
                return Ok("Edited user.");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
             
        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            try
            {
                await _usersService.DeleteUserAsync(id);
            }
            catch(ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }

            return Ok("Deleted Succesfully");
        }

        [Authorize]
        [HttpGet("history/{id}")]
        public async Task<IActionResult> History(Guid id)
        {
            try
            {
                List<Purchase> purchases = await _usersService.GetUserHistory(id);
                return Ok(purchases);
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
            
        }

    }
}

