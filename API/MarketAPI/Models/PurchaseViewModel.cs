using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models
{
    public class PurchaseViewModel
    {
        [Required]
        public decimal Price { get; set; }
        [Required]
        public string Address { get; set; }
        [Required]
        public Guid BuyerId { get; set; }
        [Required]
        public ICollection<OrderViewModel> Orders { get; set; }
        [Required]
        public int BillingDetailsId { get; set; }
    }
}
