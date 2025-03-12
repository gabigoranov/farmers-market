using Google.Cloud.Firestore;
using System;
using System.Collections.Generic;

namespace Market.Models.DTO
{
    [FirestoreData]
    public class FirestoreOfferDTO
    {
        [FirestoreProperty]
        public int id { get; set; }

        [FirestoreProperty]
        public string title { get; set; }

        [FirestoreProperty]
        public string town { get; set; }

        [FirestoreProperty]
        public string description { get; set; }

        public decimal avgRating { get; set; }

        [FirestoreProperty]
        public decimal pricePerKG { get; set; }

        [FirestoreProperty]
        public string ownerId { get; set; }

        [FirestoreProperty]
        public int stockId { get; set; }

        [FirestoreProperty]
        public FirestoreStockDTO? stock { get; set; }

        [FirestoreProperty]
        public DateTime datePosted { get; set; }

        [FirestoreProperty]
        public int discount { get; set; }
    }
}
