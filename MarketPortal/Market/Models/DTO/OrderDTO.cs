using Market.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace Market.Models.DTO
{
    public class OrderDTO
    {
        public int Id { get; set; }
        public int BillingDetailsId { get; set; }
        public string Title { get; set; }

        public bool IsAccepted { get; set; } = false;

        public bool IsDenied { get; set; } = false;

        public decimal Quantity { get; set; }
        public decimal Price { get; set; }
        public string Address { get; set; }

        public bool IsDelivered { get; set; } = false;

        public int OfferId { get; set; }

        public Guid BuyerId { get; set; }

        public Guid SellerId { get; set; }

        public DateTime DateOrdered { get; set; }

        public DateTime? DateDelivered { get; set; } = null;
    }
}
