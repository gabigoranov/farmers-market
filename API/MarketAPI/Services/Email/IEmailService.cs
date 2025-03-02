namespace MarketAPI.Services.Email
{
    public interface IEmailService
    {
        public Task SendEmailAsync(string toEmail, string subject, string templateName, object model);

    }
}
