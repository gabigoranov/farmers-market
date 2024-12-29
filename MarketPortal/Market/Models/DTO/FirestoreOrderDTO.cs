using Google.Cloud.Firestore;
using Market.Data.Models;
using System;

namespace Market.Models.DTO
{
    [FirestoreData]
    public class FirestoreOrderDTO
    {
        [FirestoreProperty]
        public int id { get; set; }

        [FirestoreProperty]
        public string title { get; set; } = string.Empty;

        [FirestoreProperty]
        public bool isAccepted { get; set; }

        [FirestoreProperty]
        public bool isDenied { get; set; }

        [FirestoreProperty]
        public double quantity { get; set; }

        [FirestoreProperty]
        public double price { get; set; }

        [FirestoreProperty]
        public string address { get; set; } = string.Empty;

        [FirestoreProperty]
        public bool isDelivered { get; set; } = false;

        [FirestoreProperty]
        public int offerId { get; set; }

        [FirestoreProperty]
        public FirestoreOfferDTO offer { get; set; }

        [FirestoreProperty]
        public string? buyerId { get; set; }

        [FirestoreProperty]
        public string? sellerId { get; set; }

        [FirestoreProperty]
        public DateTime? dateOrdered { get; set; }

        [FirestoreProperty]
        public DateTime? dateDelivered { get; set; } = null;

        [FirestoreProperty]
        public int offerTypeId { get; set; }

        [FirestoreProperty]
        public int? billingDetailsId { get; set; }
    }
}
