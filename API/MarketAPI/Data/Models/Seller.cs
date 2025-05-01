
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Seller : User
    {
        [NotMapped]
        [Required]
        public decimal Rating
        {
            get => Offers.Any() ?(Offers.Select(x => x.AvgRating).Sum()  / Offers.Count) : 0m;
        }
        public virtual List<Order> SoldOrders { get; set; } = new List<Order>();
        public List<Offer> Offers { get; set; } = new List<Offer>();

        [ForeignKey(nameof(AdvertiseSettings))]
        public int? AdvertiseSettingsId { get; set; }

        public virtual AdvertiseSettings? AdvertiseSettings { get; set; }


    }
}
