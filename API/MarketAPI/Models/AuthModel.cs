using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models
{
    public class AuthModel
    {
        [Required]
        [DataType(DataType.Password)]
        [StringLength(24, MinimumLength = 8)]
        public string Password { get; set; }
        [Required]
        [EmailAddress]
        public string Email { get; set; }
    }
}
