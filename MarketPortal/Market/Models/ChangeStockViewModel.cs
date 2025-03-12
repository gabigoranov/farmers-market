using System.ComponentModel.DataAnnotations;

namespace Market.Models
{
    public class ChangeStockViewModel
    {
        [Required]
        public int Id { get; set; }
        [Required]
        public decimal Quantity { get; set; }
    }
}
