using System.ComponentModel.DataAnnotations;
using System.ComponentModel.DataAnnotations.Schema;

namespace MarketAPI.Data.Models
{
    public class Organization : User
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
