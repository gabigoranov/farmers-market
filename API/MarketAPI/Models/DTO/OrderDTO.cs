﻿using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.DTO
{
    public class OrderDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Status { get; set; } = "None";

        public decimal Quantity { get; set; }
        public decimal Price { get; set; }
        public string Address { get; set; }

        public int OfferId { get; set; }

        public int BillingDetailsId { get; set; }
        public BillingDetailsDTO BillingDetails { get; set; }
        public int OfferTypeId { get; set; }
        public OfferType OfferType { get; set; }

        public Guid? BuyerId { get; set; }

        public Guid? SellerId { get; set; }

        public DateTime DateOrdered { get; set; }

        public DateTime? DateDelivered { get; set; } = null;
    }
}
