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
    /// <summary>
    /// Provides endpoints for managing user information and retrieving user data.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class UsersController : ControllerBase
    {
        private readonly IUsersService _usersService;
        private readonly IOffersService _offerService;

        /// <summary>
        /// Initializes a new instance of the <see cref="UsersController"/> class.
        /// </summary>
        /// <param name="usersService">The service used for managing users.</param>
        /// <param name="offerService">The service used for managing offers.</param>
        public UsersController(IUsersService usersService, IOffersService offerService)
        {
            _usersService = usersService;
            _offerService = offerService;
        }

        /// <summary>
        /// Retrieves a list of users based on the provided list of user IDs.
        /// </summary>
        /// <param name="userIds">A list of user IDs to fetch users.</param>
        /// <returns>A list of user DTOs.</returns>
        [HttpPost("/api/[controller]")]
        public async Task<IActionResult> All([FromBody] List<string> userIds)
        {
            List<UserDTO> users = await _usersService.GetUsersAsync(userIds);
            return Ok(users);
        }

        /// <summary>
        /// Retrieves the details of a specific user.
        /// </summary>
        /// <param name="id">The ID of the user to retrieve.</param>
        /// <returns>The user details or a NotFound response if the user does not exist.</returns>
        [Authorize]
        [HttpGet("{id}")]
        public async Task<IActionResult> Get([FromRoute] Guid id)
        {
            UserDTO? user = await _usersService.GetUserAsync(id);
            if (user == null) return NotFound();
            return Ok(user);
        }

        /// <summary>
        /// Retrieves the details of a specific seller.
        /// </summary>
        /// <param name="id">The ID of the seller to retrieve.</param>
        /// <returns>The seller details or a NotFound response if the seller does not exist.</returns>
        [Authorize]
        [HttpGet("seller/{id}")]
        public async Task<IActionResult> GetSeller([FromRoute] Guid id)
        {
            SellerDTO? seller = await _usersService.GetSellerAsync(id);
            if (seller == null) return NotFound("User with specified id does not exist.");
            return Ok(seller);
        }

        /// <summary>
        /// Edits the details of a specific user.
        /// </summary>
        /// <param name="id">The ID of the user to edit.</param>
        /// <param name="model">The model containing the new user details.</param>
        /// <returns>A message indicating the result of the edit operation.</returns>
        [Authorize]
        [HttpPut("{id}")]
        public async Task<IActionResult> Edit([FromRoute] Guid id, [FromBody] AddUserViewModel model)
        {
            if (!ModelState.IsValid)
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

        /// <summary>
        /// Deletes a specific user based on the user ID.
        /// </summary>
        /// <param name="id">The ID of the user to delete.</param>
        /// <returns>A message indicating the result of the delete operation.</returns>
        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete(Guid id)
        {
            try
            {
                await _usersService.DeleteUserAsync(id);
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }

            return Ok("Deleted Succesfully");
        }

        /// <summary>
        /// Retrieves the purchase history of a specific user.
        /// </summary>
        /// <param name="id">The ID of the user whose purchase history is to be fetched.</param>
        /// <returns>A list of the user's past purchases or a NotFound response if no purchases are found.</returns>
        [Authorize]
        [HttpGet("history/{id}")]
        public async Task<IActionResult> History(Guid id)
        {
            try
            {
                List<PurchaseDTO> purchases = await _usersService.GetUserHistory(id);
                return Ok(purchases);
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Retrieves incoming orders for a specific seller.
        /// </summary>
        /// <param name="id">The ID of the seller whose incoming orders are to be fetched.</param>
        /// <returns>A list of the seller's incoming orders or a NotFound response if no orders are found.</returns>
        [HttpGet("{id}/incoming")]
        [Authorize]
        public async Task<IActionResult> GetIncomingOrders(Guid id)
        {
            IEnumerable<OrderDTO>? orders = await _usersService.GetSellerOrdersAsync(id);
            if (orders == null) return NotFound("User does not exist.");
            return Ok(orders);
        }

        /// <summary>
        /// Retrieves the offers made by a specific seller.
        /// </summary>
        /// <param name="id">The ID of the seller whose offers are to be fetched.</param>
        /// <returns>A list of the seller's offers or a NotFound response if no offers are found.</returns>
        [HttpGet("{id}/offers")]
        [Authorize]
        public IActionResult GetUserOffers(Guid id)
        {
            IEnumerable<OfferWithUnitsSoldDTO>? offers = _offerService.GetSellerOffers(id);
            if (offers == null) return NotFound("User does not exist or has no offers.");
            return Ok(offers);
        }
    }
}
