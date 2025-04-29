using FirebaseAdmin.Messaging;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using FirebaseAdmin.Auth;

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
                    Body = body,
                    
                },
                Android = new AndroidConfig()
                {
                    Notification = new AndroidNotification()
                    {
                        Icon = "ic_notification"
                    }
                },
                Data = new Dictionary<string, string>
                {
                    { "id", id.ToString() },
                    { "status", status },
                    { "type", "orderUpdate" },
                }
            };

            try
            {
                if (!string.IsNullOrEmpty(deviceToken))
                    await FirebaseMessaging.DefaultInstance.SendAsync(message);
            }
            catch { }
        }

        public async Task<string> GenerateTokenAsync(string userId)
        {
            var customToken = await FirebaseAuth.DefaultInstance.CreateCustomTokenAsync(userId);
            return customToken;
        }
    }
}
