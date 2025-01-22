using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Billing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Provides endpoints for managing billing details, including retrieval, creation, editing, and deletion.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class BillingController : ControllerBase
    {
        private readonly IBillingService _billingService;

        /// <summary>
        /// Initializes a new instance of the <see cref="BillingController"/> class.
        /// </summary>
        /// <param name="billingService">Service for managing billing operations.</param>
        public BillingController(IBillingService billingService)
        {
            _billingService = billingService;
        }

        /// <summary>
        /// Retrieves the billing details for the specified ID.
        /// </summary>
        /// <param name="id">The ID of the billing details to retrieve.</param>
        /// <returns>The billing details if found, or a NotFound response if the ID does not exist.</returns>
        [HttpGet("{id}")]
        public async Task<IActionResult> Get([FromRoute] int id)
        {
            try
            {
                BillingDetailsDTO entity = await _billingService.GetAsync(id);
                return Ok(entity);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Creates a new billing entry.
        /// </summary>
        /// <param name="model">The billing details to create.</param>
        /// <returns>The ID of the newly created billing entry.</returns>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] BillingDetails model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            try
            {
                int id = await _billingService.CreateAsync(model);
                return Ok(id);
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Deletes the billing details for the specified ID.
        /// </summary>
        /// <param name="id">The ID of the billing details to delete.</param>
        /// <returns>A success message if deletion is successful, or a NotFound response if the ID does not exist.</returns>
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {
            try
            {
                await _billingService.DeleteAsync(id);
                return Ok("Deleted successfully");
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }

        /// <summary>
        /// Updates the billing details for the specified ID.
        /// </summary>
        /// <param name="id">The ID of the billing details to update.</param>
        /// <param name="model">The updated billing details.</param>
        /// <returns>A success message if the update is successful, or a NotFound response if the ID does not exist.</returns>
        [HttpPut("{id}")]
        public async Task<IActionResult> Edit([FromRoute] int id, [FromBody] BillingDetails model)
        {
            if (!ModelState.IsValid)
                return BadRequest(ModelState);
            try
            {
                await _billingService.EditAsync(id, model);
                return Ok("Edited successfully");
            }
            catch (KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }
    }
}
