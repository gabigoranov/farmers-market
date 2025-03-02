﻿using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.DTO
{
    public class OrderDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }

        public bool IsAccepted { get; set; } = false;

        public bool IsDenied { get; set; } = false;

        public double Quantity { get; set; }
        public double Price { get; set; }
        public string Address { get; set; }

        public bool IsDelivered { get; set; } = false;

        public int OfferId { get; set; }

        public int BillingDetailsId { get; set; }
<<<<<<< HEAD
        public BillingDetailsDTO BillingDetails { get; set; }
=======
>>>>>>> 89a272e372ab11c12649bea24dd0478fcafe9bf8
        public int OfferTypeId { get; set; }
        public OfferType OfferType { get; set; }

        public Guid? BuyerId { get; set; }

        public Guid? SellerId { get; set; }

        public DateTime DateOrdered { get; set; }

        public DateTime? DateDelivered { get; set; } = null;
    }
}
