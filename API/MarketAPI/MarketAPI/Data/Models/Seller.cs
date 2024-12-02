
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Seller : User
    {
        [NotMapped]
        [Required]
        public double Rating
        {
            get => Offers.Any() ? Offers.Select(x => x.AvgRating).Sum() / Offers.Count : 0;
        }
        public virtual ICollection<Order> SoldOrders { get; set; } = new List<Order>();
        public List<Offer> Offers { get; set; } = new List<Offer>();


    }
}
