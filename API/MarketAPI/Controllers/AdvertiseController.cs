using MarketAPI.Models;
using MarketAPI.Services.Advertise;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class AdvertiseController : ControllerBase
    {
        private readonly IAdvertiseService _advertiseService;

        public AdvertiseController(IAdvertiseService advertiseService)
        {
            _advertiseService = advertiseService;
        }

        [HttpPost]
        public async Task<IActionResult> Create([FromBody] AddAdvertiseSettingsViewModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Model is invalid!");
            }

            try
            {
                await _advertiseService.Create(model);
                return Ok("Advertise settings created successfully");
            }
            catch (InvalidDataException ex)
            {
                return BadRequest("No offers connected to the model were found");
            }
            catch (Exception ex)
            {
                return StatusCode(StatusCodes.Status500InternalServerError, $"Internal server error: {ex.Message}");
            }
        }
    }
}
