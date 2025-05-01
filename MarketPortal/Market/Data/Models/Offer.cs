using Microsoft.AspNetCore.Mvc;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace Market.Data.Models
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

        [Required]
        [StringLength(300)]
        public string Description { get; set; }

        public decimal AvgRating { get; set; }
        

        [Required]
        public decimal PricePerKG { get; set; }
        [Required]
        [ForeignKey(nameof(User))]
        public Guid OwnerId { get; set; }
        //public User Owner { get; set; }

        [Required]
        [ForeignKey(nameof(Stock))]
        public int StockId { get; set; }

        public virtual List<Review> Reviews { get; set; } = new List<Review>();


        public Stock Stock { get; set; }

        [Required]
        public DateTime DatePosted { get; set; }

        [Required]
        [Range(minimum: 5, maximum: 20)]
        public int Discount { get; set; }

        [ForeignKey(nameof(AdvertiseSettings))]
        public int? AdvertiseSettingsId { get; set; }

        public virtual AdvertiseSettings? AdvertiseSettings { get; set; }

    }
}
