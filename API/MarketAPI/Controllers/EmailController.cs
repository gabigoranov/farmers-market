﻿using MarketAPI.Models.Common.Email.Models;
using MarketAPI.Services.Email;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace MarketAPI.Controllers
{
    [Route("api/[controller]")]
    [ApiController]
    public class EmailController : ControllerBase
    {
        private readonly IEmailService _emailService;

        public EmailController(IEmailService emailService)
        {
            _emailService = emailService;
        }

        /// <summary>
        /// Sends a registration confirmation email to the user.
        /// </summary>
        /// <param name="request">Request containing user details and recipient email.</param>
        /// <returns>Status of the email sending process.</returns>
        [HttpPost("send-registration-email")]
        public async Task<IActionResult> SendRegistrationEmail([FromBody] RegistrationEmailRequest request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Email))
            {
                return BadRequest("Invalid email request.");
            }

            try
            {
                // Populate the email template with the user's details
                var emailModel = new
                {
                    UserName = request.UserName,
                    ActivationLink = request.ActivationLink,
                    Year = DateTime.Now.Year.ToString()
                };

                // Send the email using the template
                await _emailService.SendEmailAsync(
                    toEmail: request.Email,
                    subject: "Welcome to Freshly Groceries!",
                    templateName: "RegistrationConfirmation",
                    model: emailModel
                );

                return Ok("Registration email sent successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error sending email: {ex.Message}");
            }
        }
    }
}
