using Market.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace Market.Models
{
    public class OrganizationViewModel
    {
        [Key]
        public Guid Id { get; set; }

        [Required]
        [StringLength(12)]
        public virtual string FirstName { get; set; }

        [Required]
        [StringLength(12)]
        public virtual string LastName { get; set; }

        [Required]
        [EmailAddress]
        public string Email { get; set; }

        public virtual DateTime BirthDate { get; set; } = new DateTime(2000, 1, 1);

        [Required]
        [Phone]
        public string PhoneNumber { get; set; }

        [Required]
        [DataType(DataType.Password)]
        [StringLength(24, MinimumLength = 8)]
        public string Password { get; set; }

        [StringLength(220)]
        public string? Description { get; set; }

        [Required]
        public string Town { get; set; }
        [Required]
        public int Discriminator { get; set; }
        [Required]
        public string OrganizationName { get; set; }

        public Guid NotificationPreferencesId { get; set; } = new Guid();
        public NotificationPreferences NotificationPreferences { get; set; } = new NotificationPreferences();
    }
}