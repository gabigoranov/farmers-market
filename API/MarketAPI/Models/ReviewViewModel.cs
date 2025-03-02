using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models
{
    public class ReviewViewModel
    {
        [Key]
        public int Id { get; set; }


        [Required]
        [ForeignKey(nameof(Offer))]
        public int OfferId { get; set; }

        [Required]
        [StringLength(250)]
        public string Description { get; set; }

        [Required]
        [Range(0, 5)]
        public double Rating { get; set; }
        [Required]
        public string FirstName { get; set; }
        public string LastName { get; set; }
    }
}
