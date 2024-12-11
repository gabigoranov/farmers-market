import 'package:market/models/offer.dart';


class Token{
  int id;
  String refreshToken;
  DateTime expiryDateTime;
  String userId;

  Token({required this.id, required this.refreshToken, required this.expiryDateTime, required this.userId,  });

  factory Token.fromJson(Map<String, dynamic> json) {
    Token res = Token(
      id: json['id'] as int,
      refreshToken: json['refreshToken'] as String,
      expiryDateTime: DateTime.parse(json['expiryDateTime']),
      userId: json['refreshToken'] as String,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'refreshToken': refreshToken,
      'expiryDateTime': expiryDateTime,
      'userId': userId,
    };
  }
}