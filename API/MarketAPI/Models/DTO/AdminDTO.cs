namespace MarketAPI.Models.DTO
{
    public class AdminDTO : UserDTO
    {
        public bool IsAdmin { get; set; } = true;
    }
}
