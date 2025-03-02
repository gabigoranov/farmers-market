using Google.Cloud.Firestore;

namespace Market.Models.DTO
{
    [FirestoreData]
    public class FirestoreCartDTO
    {
        [FirestoreProperty]
        public string userId { get; set; }
        [FirestoreProperty]
        public List<FirestoreOrderDTO> orders { get; set; }
    }
}
