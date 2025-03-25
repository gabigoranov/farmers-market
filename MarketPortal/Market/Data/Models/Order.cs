﻿using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;
using NuGet.Protocol.Plugins;
using Market.Data.Models;

namespace Market.Data.Models
{

    public class Order
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Title { get; set; }

        [Required]
        public string Status { get; set; }


        [Required]
        public decimal Quantity { get; set; }
        [Required]
        public decimal Price { get; set; }
        [Required]
        public string Address { get; set; }

        [Required]
        [ForeignKey(nameof(Offer))]
        public int OfferId { get; set; }
        public Offer? Offer { get; set; }

        public Guid BuyerId { get; set; }
        public User? Buyer { get; set; }

        public Guid? SellerId { get; set; }
        public User? Seller { get; set; }

        [Required]
        public DateTime DateOrdered { get; set; }

        public DateTime? DateDelivered { get; set; } = null;

        [Required]
        [ForeignKey(nameof(OfferType))]
        public int OfferTypeId { get; set; }

        public OfferType? OfferType { get; set; }

        [Required]
        [ForeignKey(nameof(BillingDetails))]

        public int BillingDetailsId { get; set; }
        public BillingDetails? BillingDetails { get; set; }
    }
}
