using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Market.Data.Models
{
    /// <summary>
    /// Represents a user's notification preferences and settings.
    /// </summary>
    public class NotificationPreferences
    {
        /// <summary>
        /// Gets or sets a value indicating whether message notifications are enabled.
        /// </summary>
        /// <value><c>true</c> if message notifications are enabled; otherwise, <c>false</c>. Default is <c>true</c>.</value>
        [ForeignKey(nameof(User))]
        [Key]
        [Required]
        public Guid UserId { get; set; }

        /// <summary>
        /// Gets or sets a value indicating whether notifications are globally enabled for the user.
        /// </summary>
        /// <value><c>true</c> if notifications are enabled; otherwise, <c>false</c>. Default is <c>true</c>.</value>
        public bool ShowNotifications { get; set; } = true;

        /// <summary>
        /// Gets or sets a value indicating whether purchase update notifications are enabled.
        /// </summary>
        /// <value><c>true</c> if purchase update notifications are enabled; otherwise, <c>false</c>. Default is <c>true</c>.</value>
        public bool ShowPurchaseUpdateNotifications { get; set; } = true;

        /// <summary>
        /// Gets or sets a value indicating whether product suggestion notifications are enabled.
        /// </summary>
        /// <value><c>true</c> if suggestion notifications are enabled; otherwise, <c>false</c>. Default is <c>true</c>.</value>
        public bool ShowSuggestionNotifications { get; set; } = true;

        /// <summary>
        /// Gets or sets a value indicating whether message notifications are enabled.
        /// </summary>
        /// <value><c>true</c> if message notifications are enabled; otherwise, <c>false</c>. Default is <c>true</c>.</value>
        public bool ShowMessageNotifications { get; set; } = true;


    }
}
