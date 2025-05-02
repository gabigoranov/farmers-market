using MarketAPI.Models.Common.Email.Models;
using MarketAPI.Services.Email;
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
        public async Task<IActionResult> SendRegistrationEmail([FromBody] RegistrationEmailModel request)
        {
            if (request == null || string.IsNullOrWhiteSpace(request.Email))
            {
                return BadRequest("Invalid email request.");
            }

            try
            {
                // Send the email using the template
                await _emailService.SendEmailAsync(
                    toEmail: request.Email,
                    subject: "Welcome to Freshly Groceries!",
                    templateName: "RegistrationConfirmation",
                    model: request
                );

                return Ok("Register email sent successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error sending email: {ex.Message}");
            }
        }

        /// <summary>
        /// Sends a purchase confirmation email to the user.
        /// </summary>
        /// <param name="model">All the needed data for the process.</param>
        /// <returns>Status of the email sending process.</returns>
        [HttpPost("send-purchase-confirmation-email")]
        public async Task<IActionResult> SendPurchaseConfirmationEmail([FromBody] ConfirmationEmailModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Invalid email request.");
            }

            try
            {
                // Send the email using the template
                await _emailService.SendEmailAsync(
                    toEmail: model.Email,
                    subject: "Welcome to Freshly Groceries!",
                    templateName: "PurchaseConfirmation",
                    model: model
                );

                return Ok("Purchase email sent successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error sending email: {ex.Message}");
            }
        }

        /// <summary>
        /// Sends a purchase confirmation email to the user.
        /// </summary>
        /// <param name="model">All the needed data for the process.</param>
        /// <returns>Status of the email sending process.</returns>
        [HttpPost("send-advertise-confirmation-email")]
        public async Task<IActionResult> SendAdvertiseConfirmationEmail([FromBody] AdvertiseEmailModel model)
        {
            if (!ModelState.IsValid)
            {
                return BadRequest("Invalid email request.");
            }

            try
            {
                // Send the email using the template
                await _emailService.SendEmailAsync(
                    toEmail: model.Email,
                    subject: "Advertise Test!",
                    templateName: "AdvertiseConfirmation",
                    model: model
                );

                return Ok("Advertise email sent successfully.");
            }
            catch (Exception ex)
            {
                return StatusCode(500, $"Error sending email: {ex.Message}");
            }
        }
    }
}
