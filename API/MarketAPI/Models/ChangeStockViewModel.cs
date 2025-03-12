using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Models
{
    public class ChangeStockViewModel
    {
        [Required]
        [Key]
        public int Id { get; set; }
        [Required]
        public decimal Quantity { get; set; }
    }
}
