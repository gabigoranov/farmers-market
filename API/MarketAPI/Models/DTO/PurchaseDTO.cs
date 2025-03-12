using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.DTO
{
    public class PurchaseDTO
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public DateTime DateOrdered { get; set; }

        public DateTime? DateDelivered { get; set; } = null;

        public bool IsDelivered { get; set; } = false;

        public bool IsApproved { get; set; } = false;

        [Required]
        public decimal Price { get; set; }
        [Required]
        public string Address { get; set; }

        [Required]
        [ForeignKey(nameof(User))]
        public Guid? BuyerId { get; set; }
        public UserDTO Buyer { get; set; }

        [Required]
        [ForeignKey(nameof(BillingDetails))]
        public int BillingDetailsId { get; set; }
        public BillingDetailsDTO? BillingDetails { get; set; }

        public List<OrderDTO> Orders { get; set; } = new List<OrderDTO>();
    }
}
