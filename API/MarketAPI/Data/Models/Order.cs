using System;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Order
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Title { get; set; }

        public bool IsAccepted { get; set; } = false;

        public bool IsDenied { get; set; } = false;

        [Required]
        public decimal Quantity { get; set; }
        [Required]
        public decimal Price { get; set; }
        [Required]
        public string Address { get; set; }

        public bool IsDelivered { get; set; } = false;

        [Required]
        [ForeignKey(nameof(Offer))]
        public int OfferId { get; set; }
        public Offer Offer { get; set; }

        public Guid? BuyerId { get; set; }
        public User Buyer { get; set; }

        public Guid? SellerId { get; set; }
        public Seller Seller { get; set; }

        [Required]
        [ForeignKey(nameof(OfferType))]
        public int OfferTypeId { get; set; }
        public OfferType OfferType { get; set; }

        [Required]
        public DateTime DateOrdered { get; set; } = DateTime.UtcNow;

        public DateTime? DateDelivered { get; set; } = null;
        [Required]
        [ForeignKey(nameof(BillingDetails))]

        public int BillingDetailsId { get; set; }
        public BillingDetails? BillingDetails { get; set; }

    }
}
