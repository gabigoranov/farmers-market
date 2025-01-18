using System.ComponentModel.DataAnnotations.Schema;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models.DTO
{
    public class OrganizationDTO : UserDTO
    {
        [NotMapped]
        public new string FirstName { get; set; }

        [NotMapped]
        public new string LastName { get; set; }

        [NotMapped]
        public new int Age { get; set; }

        [Required]
        public string OrganizationName { get; set; }
    }
}
