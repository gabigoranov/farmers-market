﻿using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.DTO
{
    public class UserDTO
    {
        [Key]
        public Guid Id { get; set; }

        [StringLength(12)]
        public virtual string? FirstName { get; set; }

        [StringLength(12)]
        public virtual string? LastName { get; set; }

        [Required]
        public virtual DateTime BirthDate { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [Phone]
        public string PhoneNumber { get; set; }

        [StringLength(220)]
        public string? Description { get; set; }

        [Required]
        public string Town { get; set; }

        [Required]
        public int Discriminator { get; set; }

        public string? FirebaseToken { get; set; }

        public int? TokenId { get; set; }

        public virtual TokenDTO? Token { get; set; }

        public List<PurchaseDTO> BoughtPurchases { get; set; } = new List<PurchaseDTO>();
        public List<OrderDTO> BoughtOrders { get; set; } = new List<OrderDTO>();
        public virtual List<BillingDetailsDTO>? BillingDetails { get; set; }
    }
}
