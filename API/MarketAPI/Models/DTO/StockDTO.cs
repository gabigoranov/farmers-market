using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.DTO
{
    public class StockDTO
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Title { get; set; }
        [Required]
        [ForeignKey(nameof(OfferType))]
        public int OfferTypeId { get; set; }
        public OfferType OfferType { get; set; }

        [Required]
        [ForeignKey(nameof(User))]
        public Guid SellerId { get; set; }
        //public SellerDTO Seller { get; set; }

        //public List<OfferDTO> Offers { get; set; }

        [Required]
        public double Quantity { get; set; }
    }
}
