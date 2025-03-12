using MarketAPI.Data.Models;
using MarketAPI.Models.DTO;

namespace MarketAPI.Models.Common.Email.Models
{
    public class ConfirmationEmailModel
    {
        public ConfirmationEmailModel(string email, List<ConfirmationEmailOrderDTO> orders, decimal price, BillingDetailsDTO billingDetails, int year, string userName)
        {
            Email = email;
            Orders = orders;
            Price = price;
            BillingDetails = billingDetails;
            Year = year;
            UserName = userName;
        }
        public string UserName { get; set; }
        public string Email { get; set; }
        public List<ConfirmationEmailOrderDTO> Orders { get; set; }
        public decimal Price { get; set; }
        public BillingDetailsDTO BillingDetails { get; set; }
        public int Year { get; set; }
    }
}
