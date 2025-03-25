using MarketAPI.Data.Models;

namespace MarketAPI.Models.DTO.Statistics
{
    public class StatisticsOrderDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }
        public string Status { get; set; } = "None";

        public decimal Quantity { get; set; }
        public decimal Price { get; set; }
        public string Address { get; set; }

        public int OfferId { get; set; }

        public int BillingDetailsId { get; set; }
        public int OfferTypeId { get; set; }
        public OfferType OfferType { get; set; }
        public OfferDTO Offer { get; set; }

        public Guid? BuyerId { get; set; }

        public Guid? SellerId { get; set; }

        public DateTime DateOrdered { get; set; }

        public DateTime? DateDelivered { get; set; } = null;
    }
}
