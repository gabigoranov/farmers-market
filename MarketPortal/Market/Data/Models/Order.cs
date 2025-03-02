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
        public bool IsAccepted { get; set; }

        [Required]
        public bool IsDenied { get; set; }

        [Required]
        public double Quantity { get; set; }
        [Required]
        public double Price { get; set; }
        [Required]
        public string Address { get; set; }

        public bool IsDelivered { get; set; } = false;

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
        [ForeignKey(nameof(BillingDetails))]

        public int BillingDetailsId { get; set; }
        public BillingDetails? BillingDetails { get; set; }
    }
}
