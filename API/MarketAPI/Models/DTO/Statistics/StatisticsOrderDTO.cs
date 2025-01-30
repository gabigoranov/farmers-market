using MarketAPI.Data.Models;

namespace MarketAPI.Models.DTO.Statistics
{
    public class StatisticsOrderDTO
    {
        public int Id { get; set; }
        public string Title { get; set; }

        public bool IsAccepted { get; set; } = false;

        public bool IsDenied { get; set; } = false;

        public double Quantity { get; set; }
        public double Price { get; set; }
        public string Address { get; set; }

        public bool IsDelivered { get; set; } = false;

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
