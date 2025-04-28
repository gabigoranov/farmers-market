using Google.Cloud.Firestore;

namespace Market.Models.DTO
{
    [FirestoreData]

    public class FirestoreMessageDTO
    {
        [FirestoreProperty(Name = "id")]
        public int? Id { get; set; }
        [FirestoreProperty(Name = "senderId")]
        public string SenderId { get; set; }
        [FirestoreProperty(Name = "recipientId")]
        public string RecipientId { get; set; }
        [FirestoreProperty(Name = "content")]
        public string Content { get; set; }
        [FirestoreProperty(Name = "timestamp")]
        public DateTime Timestamp { get; set; }
    }
}