using Market.Data.Models;
using Market.Models.DTO;
using System.ComponentModel.DataAnnotations;

namespace Market.Models
{
    public class ProfileViewModel
    {
        public User User { get; set; }
        public List<OrderDTO>? Orders { get; set; }
        public List<Review>? Reviews { get; set; }
        public List<Offer>? Offers { get; set; }
        public List<Stock>? Stocks { get; set; }
    }
}
