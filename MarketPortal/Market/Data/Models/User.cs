using Market.Models.DTO;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Hosting;
using NuGet.Common;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Market.Data.Models
{
    public class User
    {

        [Key]
        public Guid Id { get; set; }

        [Required]
        [StringLength(12)]
        public  string? FirstName { get; set; }

        [Required]
        [StringLength(12)]
        public string? LastName { get; set; }

        [Required]
        public DateTime BirthDate { get; set; }


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

        public string? OrganizationName { get; set; }

        [Required]
        [ForeignKey(nameof(NotificationPreferences))]
        public Guid NotificationPreferencesId { get; set; }
        public NotificationPreferences NotificationPreferences { get; set; }

        [Required]
        public decimal Rating { get; set; } = 0;
        public List<OrderDTO> SoldOrders { get; set; } = new List<OrderDTO>();
        public List<Offer> Offers { get; set; } = new List<Offer>();

        public List<Order>? BoughtOrders { get; set; } = new List<Order>();
        public List<Purchase>? BoughtPurchases { get; set; } = new List<Purchase>();

        public int? TokenId { get; set; }

        public virtual Token? Token { get; set; }
        public virtual List<BillingDetails> BillingDetails { get; set; } = new List<BillingDetails>();

        //FOR SELLER
        [Required]
        public int? OrdersCount { get; }
        [Required]
        public int? ReviewsCount { get; }
        [Required]
        public int? PositiveReviewsCount { get; }
    }
}
