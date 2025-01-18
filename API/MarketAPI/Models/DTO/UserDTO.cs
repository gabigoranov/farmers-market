using MarketAPI.Data.Models;
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

        public virtual int? Age { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [Phone]
        public string PhoneNumber { get; set; }

        [Required]
        [StringLength(220)]
        public string Description { get; set; }

        [Required]
        public string Town { get; set; }

        [Required]
        public int Discriminator { get; set; }

        public string? FirebaseToken { get; set; }

        public int? TokenId { get; set; }

        public virtual Token? Token { get; set; }

        public ICollection<Purchase> BoughtPurchases { get; set; } = new List<Purchase>();
        public ICollection<Order> BoughtOrders { get; set; } = new List<Order>();
        public virtual List<BillingDetails>? BillingDetails { get; set; }
    }
}
