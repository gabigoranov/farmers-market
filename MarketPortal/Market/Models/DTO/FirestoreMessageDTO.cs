using Google.Cloud.Firestore;
using System.Globalization;

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
        public string TimestampRaw { get; set; }

        public DateTime Timestamp =>
                    DateTime.Parse(TimestampRaw, null, DateTimeStyles.AssumeUniversal | DateTimeStyles.AdjustToUniversal);

    }
}