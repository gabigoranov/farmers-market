﻿using MarketAPI.Data.Models;
using MarketAPI.Data;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using MarketAPI.Models;
using MarketAPI.Services.Reviews;
using Microsoft.AspNetCore.Authorization;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class ReviewsController : ControllerBase 
    {
        private readonly ApiContext _context;
        private readonly IReviewService _reviewsService;

        public ReviewsController(ApiContext context, IReviewService service)
        {
            _context = context;
            _reviewsService = service;
        }

        [Authorize]
        [HttpGet("by-offer/{id}")]
        public IActionResult Get([FromRoute] int id) {
            return Ok(_reviewsService.GetOfferReviewsAsync(id));
        }

        [HttpPost]
        [Authorize]
        public async Task<IActionResult> Create([FromBody] ReviewViewModel model)
        {
            if(!ModelState.IsValid)
                return BadRequest(ModelState);
            try 
            {
                await _reviewsService.CreateReviewAsync(model);
                return Ok("Review Added Succesfully");
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }

        }

        [Authorize]
        [HttpDelete("{id}")]
        public async Task<IActionResult> Delete([FromRoute] int id)
        {

            try
            {
                await _reviewsService.DeleteReviewAsync(id);
            }
            catch (ArgumentNullException ex)
            {
                return NotFound(ex.Message);
            }

            return Ok("Review deleted Succesfully");
        }



    }
}
