using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Models
{
    public class RequiredOrderViewModel : OrderViewModel
    {
        

        [Required]
        public int BillingDetailsId { get; set; }

        //[Required]
        //public int OfferTypeId { get; set; }
    }
}
