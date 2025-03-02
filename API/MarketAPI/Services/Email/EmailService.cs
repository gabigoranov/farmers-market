using MarketAPI.Models.Common.Email;
using Microsoft.Extensions.Options;
using System.Net.Mail;
using System.Net;

namespace MarketAPI.Services.Email
{
    public static class EmailTemplateLoader
    {
        public static string LoadTemplate(string templateName)
        {
            var templatePath = Path.Combine("Models", "Common", "Email", "Templates", $"{templateName}.html");
            return File.Exists(templatePath) ? File.ReadAllText(templatePath) : throw new FileNotFoundException("Template not found");
        }

        public static string PopulateTemplate(string template, object model)
        {
            foreach (var prop in model.GetType().GetProperties())
            {
                template = template.Replace($"{{{{{prop.Name}}}}}", prop.GetValue(model)?.ToString());
            }
            return template;
        }
    }
    public class EmailService : IEmailService
    {
        private readonly SmtpSettings _smtpSettings;

        public EmailService(IOptions<SmtpSettings> smtpSettings)
        {
            _smtpSettings = smtpSettings.Value;
        }

        public async Task SendEmailAsync(string toEmail, string subject, string templateName, object model)
        {
            var template = EmailTemplateLoader.LoadTemplate(templateName);
            var body = EmailTemplateLoader.PopulateTemplate(template, model);

            using (var client = new SmtpClient(_smtpSettings.Host, _smtpSettings.Port))
            {
                client.Credentials = new NetworkCredential(_smtpSettings.Username, _smtpSettings.Password);
                client.EnableSsl = _smtpSettings.EnableSsl;

                var mailMessage = new MailMessage
                {
                    From = new MailAddress(_smtpSettings.FromEmail, "Freshly Groceries"),
                    Subject = subject,
                    Body = body,
                    IsBodyHtml = true
                };
                mailMessage.To.Add(toEmail);

                await client.SendMailAsync(mailMessage);
            }
        }
    }
}
