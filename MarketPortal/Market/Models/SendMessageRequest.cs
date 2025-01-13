namespace Market.Models
{
    public class SendMessageRequest
    {
        public string DeviceToken { get; set; }
        public string? Title { get; set; }
        public string Body { get; set; }
        public string? SenderId { get; set; }
        public string RecipientId { get; set; }
        public string? Timestamp { get; set; }
        public string Type { get; set; }
    }
}
