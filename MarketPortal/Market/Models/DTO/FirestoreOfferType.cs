using Google.Cloud.Firestore;
using System.ComponentModel.DataAnnotations;

namespace Market.Models.DTO
{
    [FirestoreData]
    public class FirestoreOfferType
    {
        [FirestoreProperty]
        public int id { get; set; }

        [FirestoreProperty]
        public string name { get; set; }

        [FirestoreProperty]
        public string category { get; set; }
    }
}
