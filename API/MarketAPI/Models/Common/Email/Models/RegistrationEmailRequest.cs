namespace MarketAPI.Models.Common.Email.Models
{
    public class RegistrationEmailRequest
    {
        public string UserName { get; set; }
        public string Email { get; set; }
        public string ActivationLink { get; set; }
    }
}
