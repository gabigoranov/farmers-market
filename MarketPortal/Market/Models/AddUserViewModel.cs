﻿using Market.Data.Models;

namespace Market.Models
{
    public class AddUserViewModel
    {
        public IFormFile File { get; set; }
        public virtual UserViewModel User { get; set; }
    }
}
