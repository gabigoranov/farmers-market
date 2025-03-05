namespace MarketAPI.Models.Common.Email.Models
{
    public class RegistrationEmailModel
    {
        public RegistrationEmailModel(string userName, string email, string activationLink, int year)
        {
            UserName = userName;
            Email = email;
            ActivationLink = activationLink;
            Year = year;
        }

        public string UserName { get; set; }
        public string Email { get; set; }
        public string ActivationLink { get; set; }
        public int Year { get; set; }
    }
}
