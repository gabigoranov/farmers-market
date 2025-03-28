﻿using MarketAPI.Data.Models;
using System.ComponentModel.DataAnnotations;

namespace MarketAPI.Models
{
    public class AddUserViewModel
    {
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

        public string? OrganizationName { get; set; }

    }
}
