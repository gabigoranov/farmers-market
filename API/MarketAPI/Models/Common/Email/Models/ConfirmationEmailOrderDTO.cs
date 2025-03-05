using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.Common.Email.Models
{
    public class ConfirmationEmailOrderDTO
    {
        [Key]
        public int Id { get; set; }
        [Required]
        public string Title { get; set; }

        [Required]
        public double Quantity { get; set; }
        [Required]
        public double Price { get; set; }
        [Required]
        public string Address { get; set; }

        [Required]
        [DisplayFormat(DataFormatString = "{0:dd.MM.yyyy}", ApplyFormatInEditMode = true)]
        public DateTime DateOrdered { get; set; } = DateTime.UtcNow;
    }
}
