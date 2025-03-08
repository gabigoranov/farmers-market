using Microsoft.Extensions.Diagnostics.HealthChecks;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models
{
    public class EditUserViewModel
    {
        [Key]
        public Guid Id { get; set; }
        [StringLength(12)]
        public virtual string? FirstName { get; set; }

        [StringLength(12)]
        public virtual string? LastName { get; set; }

        [Required]
        public virtual DateTime BirthDate { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        [Required]
        [Phone]
        public string PhoneNumber { get; set; }

        public string? Password { get; set; }

        [StringLength(220)]
        public string? Description { get; set; }

        [Required]
        public string Town { get; set; }

        [Required]
        public int Discriminator { get; set; }

        public string? OrganizationName { get; set; }
    }
}
