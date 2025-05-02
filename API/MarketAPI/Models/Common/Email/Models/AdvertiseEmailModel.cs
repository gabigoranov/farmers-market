using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.Common.Email.Models
{
    public class AdvertiseEmailModel
    {
        public string SellerName { get; set; }
        public int Year { get; set; }

        [Required]
        public bool HasEmailCampaign { get; set; }

        [Required]
        public bool HasHighlightsSection { get; set; }

        [Required]
        public bool HasPushNotifications { get; set; }

        [Required]
        public decimal Price { get; set; }

        [Required]
        public string PaymentType { get; set; }


        [Required]
        public string Email { get; set; }

        [Required]
        public DateTime NextPaymentDue { get; set; }

    }
}
