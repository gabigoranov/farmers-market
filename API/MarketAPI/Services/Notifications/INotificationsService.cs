using MarketAPI.Data.Models;
using System.Collections.Generic;
using System.Threading.Tasks;

namespace MarketAPI.Services.Notifications
{
    /// <summary>
    /// Service for managing user notification preferences.
    /// </summary>
    public interface INotificationsService
    {
        /// <summary>
        /// Gets all notification preferences.
        /// </summary>
        /// <returns>A list of all notification preferences.</returns>
        IEnumerable<NotificationPreferences> GetAllPreferences();

        /// <summary>
        /// Gets notification preferences by user ID.
        /// </summary>
        /// <param name="userId">The ID of the user.</param>
        /// <returns>The notification preferences for the specified user.</returns>
        NotificationPreferences? GetPreferencesByUserId(Guid userId);

        /// <summary>
        /// Creates new notification preferences for a user.
        /// </summary>
        /// <param name="preferences">The notification preferences to create.</param>
        /// <returns>The created notification preferences.</returns>
        Task<NotificationPreferences> CreatePreferencesAsync(NotificationPreferences preferences, bool saveChanges);

        /// <summary>
        /// Updates existing notification preferences.
        /// </summary>
        /// <param name="userId">The ID of the user.</param>
        /// <param name="preferences">The updated notification preferences.</param>
        /// <returns>The updated notification preferences.</returns>
        Task<NotificationPreferences?> UpdatePreferencesAsync(Guid userId, NotificationPreferences preferences);

        /// <summary>
        /// Deletes notification preferences for a user.
        /// </summary>
        /// <param name="userId">The ID of the user.</param>
        /// <returns>Nothing</returns>
        Task DeletePreferences(Guid userId);

        /// <summary>
        /// Checks if notification preferences exist for a user.
        /// </summary>
        /// <param name="userId">The ID of the user.</param>
        /// <returns>True if preferences exist; otherwise false.</returns>
        Task<bool> PreferencesExistAsync(Guid userId);
    }
}