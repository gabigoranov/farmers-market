using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models
{
    public class AddAdvertiseSettingsViewModel
    {
        [Required]
        public bool HasEmailCampaign { get; set; } = false;

        [Required]
        public bool HasHighlightsSection { get; set; } = false;

        [Required]
        public bool HasPushNotifications { get; set; } = false;

        [Required]
        public string PaymentType { get; set; } = "One-Time";

        [Required]
        public string OfferIds { get; set; } = "";

        public Guid SellerId { get; set; }
    }
}
