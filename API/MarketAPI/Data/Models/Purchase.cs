using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Purchase
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public DateTime DateOrdered { get; set; } 

        public DateTime? DateDelivered { get; set; } = null;

        public bool IsDelivered { get; set; } = false;

        public bool IsApproved { get; set; } = false;

        [Required]
        public double Price { get; set; }
        [Required]
        public string Address { get; set; }

        [Required]
        [ForeignKey(nameof(User))]
        public Guid? BuyerId { get; set; }
        public User Buyer { get; set; }

        [Required]
        [ForeignKey(nameof(BillingDetails))]
        public int BillingDetailsId { get; set; }
        public BillingDetails? BillingDetails { get; set; }

        public ICollection<Order> Orders { get; set; } = new List<Order>();


    }
}
