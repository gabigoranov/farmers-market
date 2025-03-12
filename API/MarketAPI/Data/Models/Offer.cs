using Microsoft.EntityFrameworkCore.Metadata.Builders;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Offer
    {
        [Key]
        public int Id { get; set; }

        [Required]
        [StringLength(28)]
        public string Title { get; set; }

        [Required]
        [StringLength(16)]
        public string Town { get; set; }

        [NotMapped]
        public decimal AvgRating => Reviews.Count() > 0 ? Reviews.Select(x => x.Rating).Average() : 0; 

        [Required]
        [StringLength(300)]
        public string Description { get; set; }

        [Required]
        public decimal PricePerKG { get; set; }
        [Required]
        [ForeignKey(nameof(User))]
        public Guid OwnerId { get; set; }
        public Seller Owner { get; set; }

        [Required]
        [ForeignKey(nameof(Stock))]
        public int StockId { get; set; }
        
        public Stock Stock { get; set; }


        [Required]
        public DateTime DatePosted { get; set; } = DateTime.Now;

        [Required]
        [Range(minimum: 5, maximum: 20)]
        public int Discount { get; set; }

        public virtual List<Order> Orders { get; set; } = new List<Order>();

        public virtual List<Review> Reviews { get; set; } = new List<Review>();


    }
}
