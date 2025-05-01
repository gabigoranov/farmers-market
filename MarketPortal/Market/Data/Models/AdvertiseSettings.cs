using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Market.Data.Models
{
    public class AdvertiseSettings
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [ForeignKey(nameof(Seller))]
        public Guid SellerId { get; set; }

        public virtual User Seller { get; set; }

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
        public DateTime NextPaymentDue { get; set; }

        [Required]
        public List<Offer> Offers { get; set; } = new List<Offer>();
    }
}
