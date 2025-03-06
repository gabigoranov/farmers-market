using MarketAPI.Models.Common.Email;
using Microsoft.Extensions.Options;
using System.Net.Mail;
using System.Net;
using HandlebarsDotNet;

namespace MarketAPI.Services.Email
{
    public static class EmailTemplateLoader
    {

        public static string GetTemplatePath(string templateName, IWebHostEnvironment _env)
        {
            // Build the absolute path to the template file
            var templatePath = Path.Combine(
                _env.ContentRootPath,
                "Models", "Common", "Email", "Templates",
                $"{templateName}.html"
            );
            return templatePath;
        }
        public static string LoadTemplate(string templateName, IWebHostEnvironment _env)
        {
            var templatePath = GetTemplatePath(templateName, _env);
            return File.Exists(templatePath) ? File.ReadAllText(templatePath) : throw new FileNotFoundException("Template not found");
        }

        public static string PopulateTemplate(string template, object model)
        {
            var compiledTemplate = Handlebars.Compile(template);
            return compiledTemplate(model);
        }
    }
    public class EmailService : IEmailService
    {
        private readonly SmtpSettings _smtpSettings;
        private readonly IWebHostEnvironment _env;

        public EmailService(IOptions<SmtpSettings> smtpSettings, IWebHostEnvironment env)
        {
            Handlebars.RegisterHelper("formatDate", (writer, context, parameters) =>
            {
                var date = (DateTime)parameters[0]; // DateTime from model
                writer.WriteSafeString(date.ToString("yyyy-MM-dd"));
            });

            _smtpSettings = smtpSettings.Value;
            _env = env;
        }

        public async Task SendEmailAsync(string toEmail, string subject, string templateName, object model)
        {
            var template = EmailTemplateLoader.LoadTemplate(templateName, _env);
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
