namespace MarketAPI.Data.Models
{
    public class Admin : User
    {
        public bool IsAdmin { get; set; } = true;
    }
}
