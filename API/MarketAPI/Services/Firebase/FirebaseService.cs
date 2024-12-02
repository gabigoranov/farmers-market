using FirebaseAdmin.Messaging;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;

namespace MarketAPI.Services.Firebase
{
    public class FirebaseService
    {
        public FirebaseService()
        {
            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions()
                {
                    Credential = GoogleCredential.FromFile("firebase-private-key.json")
                });
            }

        }

        public async Task SendNotification(string deviceToken, string title, string body, int id, string status)
        {
            var message = new Message()
            {
                Token = deviceToken,
                Notification = new Notification()
                {
                    Title = title,
                    Body = body
                },
                Data = new Dictionary<string, string>
                {
                    { "id", id.ToString() },
                    { "status", status },
                    { "type", "orderUpdate" }
                }
            };

            await FirebaseMessaging.DefaultInstance.SendAsync(message);
        }
    }
}
