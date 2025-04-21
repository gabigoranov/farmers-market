
import 'package:market/models/notification_preferences.dart';
import 'package:market/models/purchase.dart';
import 'package:market/models/token.dart';
import 'billing_details.dart';

class User{
  String id;
  String firstName;
  String lastName;
  DateTime birthDate;
  String email;
  String phoneNumber;
  String? password;
  String? description;
  int? tokenId;
  Token? token;
  String town;
  int discriminator;
  List<Purchase> boughtOrders;
  List<BillingDetails>? billingDetails;
  String preferencesId;
  NotificationPreferences preferences;

  // Updated User constructor
  User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.email,
    required this.phoneNumber,
    this.description,
    required this.town,
    required this.discriminator,
    required this.boughtOrders,
    this.tokenId,
    this.token,
    this.billingDetails,
    this.password,
    required this.preferences,
    required this.preferencesId,
  });

  // Factory constructor to create a User instance from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    print("Parsing user");
    List<Purchase> converted = [];

    if(json['boughtPurchases'].length > 0){
      for(int i = 0; i < json['boughtPurchases'].length; i++){

        converted.add(Purchase.fromJson(json['boughtPurchases'][i]));
      }
    }
    print("parsing bd");
    List<BillingDetails> billingDetailsConverted = [];
    if(json['billingDetails'].length > 0){
      for(int i = 0; i < json['billingDetails'].length; i++){
        billingDetailsConverted.add(BillingDetails.fromJson(json['billingDetails'][i]));
      }
    }

    print("parsed bd");


    print(json);

    User res = User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      birthDate: DateTime.parse(json['birthDate']),
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      description: json['description'] as String?,
      town: json['town'] as String,
      discriminator: json['discriminator'] as int,
      tokenId: json['tokenId'] as int,
      preferencesId: json['notificationPreferencesId'] as String,
      preferences: NotificationPreferences.fromJson(json['notificationPreferences']),
      token: Token.fromJson(json['token']),
      boughtOrders: converted,
      billingDetails: billingDetailsConverted,
    );

    print("Parsed user");

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
      'password': password,
      'description': description,
      'town': town,
      'discriminator': discriminator,
      'billingDetails': billingDetails,
      'tokenId': tokenId,
      'notificationPreferencesId': preferencesId,
      'notificationPreferences': preferences
    };
  }
}