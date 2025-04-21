using Microsoft.AspNetCore.Mvc;
using MarketAPI.Data.Models;
using System.Collections.Generic;
using System.Linq;
using MarketAPI.Services.Notifications;

namespace MarketAPI.Controllers
{
    /// <summary>
    /// Controller for managing user notification preferences.
    /// </summary>
    [Route("api/[controller]")]
    [ApiController]
    public class NotificationsController : ControllerBase
    {
        private readonly INotificationsService _notificationsService;

        /// <summary>
        /// Constructor which initializes the necessary dependencies.
        /// </summary>
        public NotificationsController(INotificationsService notificationsService)
        {
            _notificationsService = notificationsService;
        }

        /// <summary>
        /// Gets all notification preferences (for demonstration purposes).
        /// </summary>
        /// <returns>A list of all notification preferences.</returns>
        [HttpGet]
        public IActionResult Get()
        {
            return Ok(_notificationsService.GetAllPreferences());
        }

        /// <summary>
        /// Gets notification preferences by User ID.
        /// </summary>
        /// <param name="userId">The ID of the notification preferences to retrieve.</param>
        /// <returns>The requested notification preferences if found; otherwise, 404 Not Found.</returns>
        [HttpGet("{userId}")]
        public IActionResult Get(Guid userId)
        {
            var preferences = _notificationsService.GetPreferencesByUserId(userId);
            if (preferences == null)
            {
                return NotFound();
            }
            return Ok(preferences);
        }

        /// <summary>
        /// Creates new notification preferences.
        /// </summary>
        /// <param name="preferences">The notification preferences to create.</param>
        /// <returns>The created notification preferences.</returns>
        [HttpPost]
        public async Task<IActionResult> Create([FromBody] NotificationPreferences preferences)
        {
            preferences = await _notificationsService.CreatePreferencesAsync(preferences);
            return Ok(preferences.UserId);
        }

        /// <summary>
        /// Updates notification preferences for a specific user.
        /// </summary>
        /// <param name="userId">The ID of the user whose preferences to update.</param>
        /// <param name="preferences">The updated notification preferences data.</param>
        /// <returns>
        /// <response code="204">If the update was successful</response>
        /// <response code="400">If the ID in the route doesn't match the ID in the body</response>
        /// <response code="404">If no preferences exist for the specified user ID</response>
        /// <response code="500">If there was an error updating the preferences</response>
        /// </returns>
        [HttpPut("{userId}")]
        [ProducesResponseType(StatusCodes.Status204NoContent)]
        [ProducesResponseType(StatusCodes.Status400BadRequest)]
        [ProducesResponseType(StatusCodes.Status404NotFound)]
        [ProducesResponseType(StatusCodes.Status500InternalServerError)]
        public async Task<IActionResult> Put(Guid userId, [FromBody] NotificationPreferences preferences)
        {
            try
            {
                // Validate ID match between route and body
                if (userId != preferences.UserId)
                {
                    return BadRequest(new
                    {
                        Message = "ID in route does not match ID in request body",
                    });
                }

                // Check if preferences exist
                var existingPreferences = _notificationsService.GetPreferencesByUserId(userId);
                if (existingPreferences == null)
                {
                    return NotFound(new
                    {
                        Message = $"Notification preferences for user ID {userId} not found",
                    });
                }

                // Update preferences
                var updateResult = await _notificationsService.UpdatePreferencesAsync(userId, preferences);
                if (updateResult == null)
                {
                    return StatusCode(StatusCodes.Status500InternalServerError, new
                    {
                        Message = "Failed to update notification preferences",
                    });
                }

                return Ok("Notification preferences were edited successfully.");
            }
            catch (Exception ex)
            {
                // Log the exception (implementation depends on your logging setup)
                // _logger.LogError(ex, "Error updating notification preferences for user {UserId}", id);

                return StatusCode(StatusCodes.Status500InternalServerError, new
                {
                    Message = "An error occurred while updating notification preferences",
                    Error = ex.Message
                });
            }
        }

        /// <summary>
        /// Deletes notification preferences.
        /// </summary>
        /// <param name="userId">The ID of the preferences to delete.</param>
        /// <returns>No content if successful; otherwise, 404 Not Found.</returns>
        [HttpDelete("{userId}")]
        public async Task<IActionResult> Delete(Guid userId)
        {
            await _notificationsService.DeletePreferences(userId);
            return NoContent();
        }
    }
}