using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Review
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string FirstName { get; set; }

        public string LastName { get; set; }

        [Required]
        [ForeignKey(nameof(Offer))]
        public int OfferId { get; set; }

        public virtual Offer Offer { get; set; }

        [Required]
        [StringLength(250)]
        public string Description { get; set; }

        [Required]
        [Range(0, 5)]
        public decimal Rating { get; set; }
    }
}
