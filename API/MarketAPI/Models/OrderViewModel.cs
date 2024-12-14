using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Models
{
    public class OrderViewModel
    {
        [Required]
        public string Title { get; set; }        
        
        [Required]
        public string Address { get; set; }
        [Required]
        public double Quantity { get; set; }
        [Required]
        public double Price { get; set; }

        [Required]
        public int OfferId { get; set; }

        [Required]
        public Guid? BuyerId { get; set; }

        [Required]
        public Guid? SellerId { get; set; }

        //[Required]
        //public int OfferTypeId { get; set; }
    }
}
