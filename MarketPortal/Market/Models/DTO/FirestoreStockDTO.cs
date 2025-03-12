using Google.Cloud.Firestore;
using System;

namespace Market.Models.DTO
{
    [FirestoreData]
    public class FirestoreStockDTO
    {
        [FirestoreProperty]
        public int id { get; set; }

        [FirestoreProperty]
        public string title { get; set; }

        [FirestoreProperty]
        public int offerTypeId { get; set; }

        [FirestoreProperty]
        public FirestoreOfferType offerType { get; set; }

        [FirestoreProperty]
        public string sellerId { get; set; }

        [FirestoreProperty]
        public decimal quantity { get; set; }
    }
}
