using Market.Data.Models;
using Market.Models.DTO;

namespace Market.Models
{
    public class OverviewViewModel
    {
        public OverviewViewModel(List<OrderDTO> orders, List<Review> reviews, List<Stock> stocks)
        {
            Orders = orders;
            Reviews = reviews;
            Stocks = stocks;
        }

        public List<OrderDTO> Orders { get; set; }
        public List<Review> Reviews { get; set; }

        public List<Stock> Stocks { get; set; }
    }
}
