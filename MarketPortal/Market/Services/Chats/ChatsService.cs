using FirebaseAdmin;
using FirebaseAdmin.Messaging;
using Google.Apis.Auth.OAuth2;

namespace Market.Services.Chats
{
    public class ChatsService : IChatsService
    {
        public ChatsService()
        {
            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions()
                {
                    Credential = GoogleCredential.FromFile("./wwwroot/credentials/firebase-key.json")
                });
            }
        }

        public async Task SendMessage(string deviceToken, string title, string body, string senderId, string recipientId, string type)
        {
            var message = new Message()
            {
                Token = deviceToken,
                Notification = new Notification()
                {
                    Title = title,
                    Body = body
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
                    { "senderId", senderId },
                    { "recipientId", recipientId },
                    { "timestamp", DateTime.UtcNow.ToString("yyyy-MM-dd HH:mm:ss.ffffffZ") },
                    { "type", type },
                }
            };

            try
            {
                if (!string.IsNullOrEmpty(deviceToken))
                    await FirebaseMessaging.DefaultInstance.SendAsync(message);
            }
            catch { }
        }
    }
}
