using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Hosting;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class User
    {

        [Key]
        public Guid Id { get; set; }

        [StringLength(12)]
        public virtual string? FirstName { get; set; }

        [StringLength(12)]
        public virtual string? LastName { get; set; }

        [Required]
        public virtual DateTime BirthDate { get; set; } = new System.DateTime(2000, 1, 1);

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [Phone]
        public string PhoneNumber { get; set; }

        [Required]
        public string Password { get; set; }

        [StringLength(220)]
        public string? Description { get; set; }

        [Required]
        public string Town { get; set; }

        [Required]
        public int Discriminator { get; set; }

        [Required]
        [ForeignKey(nameof(NotificationPreferences))]
        public Guid NotificationPreferencesId { get; set; }
        public NotificationPreferences NotificationPreferences { get; set; }

        public string? FirebaseToken { get; set; }

        public int? TokenId { get; set; }

        public virtual Token? Token { get; set; }

        public List<Purchase> BoughtPurchases { get; set; } = new List<Purchase>();
        public List<Order> BoughtOrders { get; set; } = new List<Order>();
        public virtual List<BillingDetails>? BillingDetails { get; set; }


    }
}
