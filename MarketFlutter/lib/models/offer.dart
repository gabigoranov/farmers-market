

import 'dart:convert';

import 'package:market/models/review.dart';
import 'package:market/models/stock.dart';

class Offer {
  // public int Id { get; set; }
  // public string Title { get; set; }
  // public double PricePerKG { get; set; }
  // public Guid OwnerId { get; set; }
  // public User Owner { get; set; }
  // public bool inSeason { get; set; }
  // public int OfferTypeId { get; set; }
  // public OfferType OfferType { get; set; }


  int id;
  String title;
  String town;
  String description;
  double pricePerKG;
  String ownerId;
  int stockId;
  int offerTypeId;
  String offerTypeName;
  DateTime datePosted;
  Stock stock;
  List<Review>? reviews;
  double avgRating;
  // Constructor
  Offer({required this.id, required this.title, required this.town, required this.pricePerKG, required this.ownerId, required this.stockId, required this.description, required this.avgRating, required this.datePosted, required this.offerTypeId, required this.stock, this.reviews, required this.offerTypeName});

  factory Offer.fromJson(Map<String, dynamic> json) {
    print(json);
    Offer res = Offer(
      id: json['id'] as int,
      title: json['title'] as String,
      town: json['town'] as String,
      description: json['description'] as String,
      pricePerKG: json['pricePerKG']+.0,
      ownerId: json['ownerId'] as String,
      datePosted: DateTime.parse(json['datePosted']),
      stockId: json['stockId'] as int, //TODO: fix stock DTO
      offerTypeId: json['stock']['offerTypeId'] as int,
      avgRating: json['avgRating']+.0,
      offerTypeName: json['offerType'] ?? json['stock']['offerType']['name'] as String,
      stock: Stock.fromJson(json['stock']),
      //reviews: List<Review>.from(json['reviews'].map((model)=> Review.fromJson(model))),
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    //TODO: Add all types when fix api
    return {
      'id': id,
      'title': title,
      'pricePerKG': pricePerKG,
      'ownerId': ownerId,
      'stockId': stockId,
      'description': description,
      'town': town,
      'datePosted': datePosted.toString(),
      'reviews': reviews?.map((x) => x.toJson()).toList(),
      'stock': stock.toJson(),
      'avgRating': avgRating,
    };
  }
}