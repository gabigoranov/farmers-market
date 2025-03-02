
import 'package:market/models/purchase.dart';
import 'package:market/models/token.dart';

class Contact{
  String id;
  String firstName;
  String? lastName;
  String email;
  String? firebaseToken;
  String? profilePictureURL;

  // Constructor
  Contact({required this.id, required this.firstName,
     required this.email, this.firebaseToken,  this.lastName, this.profilePictureURL});

  // Factory constructor to create a User instance from a JSON map
  factory Contact.fromJson(Map<String, dynamic> json) {
    Contact res = Contact(
      id: json['id'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String?,
      email: json['email'] as String,
      firebaseToken: json['firebaseToken'] as String?,
    );

    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {

    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'firebaseToken': firebaseToken
    };
  }
}