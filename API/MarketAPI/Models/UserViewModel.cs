using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models
{
    public class UserViewModel
    {
        [Key]
        public Guid Id { get; set; }

        [Required]
        [StringLength(12)]
        public virtual string FirstName { get; set; }

        [Required]
        [StringLength(12)]
        public virtual string LastName { get; set; }

        [Required]
        public virtual DateTime BirthDate { get; set; }


        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [Phone]
        public string PhoneNumber { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [StringLength(24, MinimumLength = 8)]
        public string Password { get; set; }

        [StringLength(220)]
        public string? Description { get; set; }

        [Required]
        public string Town { get; set; }

        [Required]
        public int Discriminator { get; set; }

        [Required]
        public bool isOrganization { get; set; }

        public string? FirebaseToken { get; set; }

        public ICollection<Purchase> BoughtPurchases { get; set; } = new List<Purchase>();
        public ICollection<Order> BoughtOrders { get; set; } = new List<Order>();


    }
}
