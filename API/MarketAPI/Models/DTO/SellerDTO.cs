using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Models.DTO
{
    public class SellerDTO : UserDTO
    {
        [NotMapped]
        [Required]
        public decimal Rating
        {
            get => Offers.Any() ? Offers.Select(x => x.AvgRating).Sum() / Offers.Count : 0;
        }
        public virtual ICollection<OrderDTO> SoldOrders { get; set; } = new List<OrderDTO>();
        public List<OfferDTO> Offers { get; set; } = new List<OfferDTO>();

        [Required]
        public int OrdersCount { get; }
        [Required]
        public int ReviewsCount { get; }
        [Required]
        public int PositiveReviewsCount { get; }
    }
}
