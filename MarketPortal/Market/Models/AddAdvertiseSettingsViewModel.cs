using Market.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Market.Models
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

        [Required]
        public List<Offer> AvailableOffers { get; set; } = new List<Offer>();

        public Guid? SellerId { get; set; }

    }
}
