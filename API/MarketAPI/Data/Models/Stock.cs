﻿using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Stock
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Title { get; set; }
        [Required]
        [ForeignKey(nameof(OfferType))]
        public int OfferTypeId { get; set; }
        public OfferType OfferType { get; set; }
        
        [Required]
        [ForeignKey(nameof(User))]
        public Guid SellerId { get; set; }
        public User Seller { get; set; }

        public List<Offer> Offers { get; set; }
        
        [Required]
        public decimal Quantity { get; set; }

        public DateTime LastUpdated { get; set; } = DateTime.Now;
    }
}
