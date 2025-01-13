using MarketAPI.Data;
using MarketAPI.Data.Models;
using MarketAPI.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Offers;
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
        private readonly IOffersService _offerService;

        public UsersController(IUsersService usersService, IOffersService offerService)
        {
            _usersService = usersService;
            _offerService = offerService;
        }

        [HttpPost("/api/[controller]")]
        public async Task<IActionResult> All([FromBody] List<string> userIds)
        {
            List<User> users = await _usersService.GetUsersAsync(userIds);
            return Ok(users);
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
        [HttpGet("seller/{id}")]
        public async Task<IActionResult> GetSeller([FromRoute] Guid id)
        {
            User? user = await _usersService.GetUserAsync(id);
            if(user == null) return NotFound("User with specified id does not exist.");
            SellerDTO seller = _usersService.ConvertToSellerDTO((Seller)user);
            return Ok(seller);
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

        [HttpGet("{id}/incoming")]
        [Authorize]
        public async Task<IActionResult> GetIncomingOrders(Guid id)
        {
            IEnumerable<OrderDTO>? orders = await _usersService.GetSellerOrdersAsync(id);
            if (orders == null) return NotFound("User does not exist.");

            return Ok(orders);
        }

        [HttpGet("{id}/offers")]
        [Authorize]
        public async Task<IActionResult> GetUserOffers(Guid id)
        {
            IEnumerable<OfferWithUnitsSoldDTO>? offers = _offerService.GetSellerOffers(id);
            if (offers == null) return NotFound("User does not exist or has no offers.");
            return Ok(offers);
        }
    }
}

