
import 'package:market/models/purchase.dart';

import 'order.dart';

class User{
  String id;
  String firstName;
  String lastName;
  int age;
  String email;
  String phoneNumber;
  String password;
  String description;
  String town;
  int discriminator;
  List<Purchase> boughtOrders;

  // Constructor
  User({required this.id, required this.firstName, required this.lastName,
        required this.age, required this.email,
        required this.phoneNumber, required this.password, required this.description,
        required this.town, required this.discriminator, required this.boughtOrders});

  // Factory constructor to create a User instance from a JSON map
  factory User.fromJson(Map<String, dynamic> json) {
    List<Purchase> converted = [];
    if(json['boughtPurchases'].length > 0){
      for(int i = 0; i < json['boughtPurchases'].length; i++){
        converted.add(Purchase.fromJson(json['boughtPurchases'][i]));
      }
    }
    User res = User(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      age: json['age'] as int,
      email: json['email'] as String,
      phoneNumber: json['phoneNumber'] as String,
      password: json['password'] as String,
      description: json['description'] as String,
      town: json['town'] as String,
      discriminator: json['discriminator'] as int,
      boughtOrders: converted,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'age': age,
      'email': email,
      'phoneNumber': phoneNumber,
      'password': password,
      'description': description,
      'town': town,
      'discriminator': discriminator,
    };
  }
}