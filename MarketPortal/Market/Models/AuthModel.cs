﻿using System.ComponentModel.DataAnnotations;

namespace Market.Models
{
    public class AuthModel
    {
        public AuthModel () { }
        public AuthModel(string email, string password)
        {
            Email = email;
            Password = password;
        }
        [Required]
        [EmailAddress]
        public string? Email { get; set; }
        [Required]
        [DataType(DataType.Password)]
        [StringLength(24, MinimumLength = 8)]
        public string? Password { get; set; }
    }
}
