namespace Market.Services.Chats
{
    public interface IChatsService
    {
        public Task SendMessage(string deviceToken, string title, string body, string senderId, string recipientId, string type);

    }
}