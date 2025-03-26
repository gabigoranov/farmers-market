
import 'package:market/models/purchase.dart';
import 'package:market/models/token.dart';
import 'billing_details.dart';
import 'offer.dart';
import 'order.dart';

class Seller{
  String id;
  String firstName;
  String lastName;
  DateTime birthDate;
  String email;
  String phoneNumber;
  String description;
  String town;
  int discriminator;
  int ordersCount;
  int reviewsCount;
  int positiveReviewsCount;
  List<Offer> offers;
  double rating;


  // Constructor
  Seller({required this.id, required this.firstName, required this.lastName,
    required this.birthDate, required this.email,
    required this.phoneNumber, required this.description,
    required this.town, required this.discriminator, required this.rating, required this.reviewsCount, required this.ordersCount, required this.positiveReviewsCount, required this.offers});

  // Factory constructor to create a User instance from a JSON map
  factory Seller.fromJson(Map<String, dynamic> json) {
    List<Offer> offersConverted = [];
    if(json['offers'].length > 0){
      for(int i = 0; i < json['offers'].length; i++){
        offersConverted.add(Offer.fromJson(json['offers'][i]));
      }
    }
    Seller res = Seller(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate']),
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      description: json['description'] as String,
      town: json['town'] as String,
      discriminator: json['discriminator'] as int,
      rating: json['rating']+0.0,
      ordersCount: json['ordersCount'] as int,
      reviewsCount: json['reviewsCount'] as int,
      positiveReviewsCount: json['positiveReviewsCount'] as int,
      offers: offersConverted
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {

    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'birthDate': birthDate.toIso8601String(),
      'email': email,
      'phoneNumber': phoneNumber,
      'description': description,
      'town': town,
      'discriminator': discriminator,
      'offers': offers,
      'rating': rating,
      'ordersCount': ordersCount,
      'reviewsCount': reviewsCount,
      'positiveReviewsCount': positiveReviewsCount
    };
  }
}