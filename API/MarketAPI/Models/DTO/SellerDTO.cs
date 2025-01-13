using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Models.DTO
{
    public class SellerDTO
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

        [NotMapped]
        [Required]
        public double Rating
        {
            get => Offers.Any() ? Offers.Select(x => x.AvgRating).Sum() / Offers.Count : 0;
        }

        [Required]
        public int OrdersCount { get; set; }
        [Required]
        public int ReviewsCount { get; set; }
        [Required]
        public int PositiveReviewsCount { get; set; }
        public List<Offer> Offers { get; set; } = new List<Offer>();
    }
}
