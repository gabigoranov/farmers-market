using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Models.DTO
{
    public class SellerDTO : UserDTO
    {
        public SellerDTO()
        {
            IEnumerable<Review> reviews = Offers.SelectMany(x => x.Reviews);
            OrdersCount = SoldOrders.Count;
            ReviewsCount = reviews.Count();
            PositiveReviewsCount = reviews.Select(x => x.Rating > 2.5).Count();
        }

        [NotMapped]
        [Required]
        public double Rating
        {
            get => Offers.Any() ? Offers.Select(x => x.AvgRating).Sum() / Offers.Count : 0;
        }
        public virtual ICollection<Order> SoldOrders { get; set; } = new List<Order>();
        public List<Offer> Offers { get; set; } = new List<Offer>();

        [Required]
        public int OrdersCount { get; }
        [Required]
        public int ReviewsCount { get; }
        [Required]
        public int PositiveReviewsCount { get; }
    }
}
