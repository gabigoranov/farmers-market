using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.DTO
{
    public class TokenDTO
    {
        [Key]
        public int Id { get; set; }

        [Required]
        public string RefreshToken { get; set; }

        [Required]
        public DateTime ExpiryDateTime { get; set; }

        [Required]
        public Guid UserId { get; set; }

        [NotMapped]
        public string AccessToken { get; set; }
    }
}
