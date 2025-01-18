using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;
using MarketAPI.Services.Billing;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    [Authorize]
    public class BillingController : ControllerBase
    {
        private readonly IBillingService _billingService;

        public BillingController(IBillingService billingService)
        {
            _billingService = billingService;
        }

        [HttpGet("{id}")]
        public async Task<IActionResult> Get([FromRoute] int id)
        {
            try
            {
                BillingDetailsDTO entity = await _billingService.GetAsync(id);
                return Ok(entity);
            }
            catch(KeyNotFoundException ex)
            {
                return NotFound(ex.Message);
            }
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] BillingDetails model)
        {
            if(!ModelState.IsValid)
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
