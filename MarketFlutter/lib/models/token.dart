

class Token{
  int id;
  String refreshToken;
  DateTime expiryDateTime;
  String userId;
  String? accessToken;

  Token({required this.id, required this.refreshToken, required this.expiryDateTime, required this.userId,  this.accessToken});

  factory Token.fromJson(Map<String, dynamic> json) {
    Token res = Token(
      id: json['id'] as int,
      refreshToken: json['refreshToken'] as String,
      expiryDateTime: DateTime.parse(json['expiryDateTime']),
      userId: json['userId'] as String,
      accessToken: json['accessToken'] as String,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'refreshToken': refreshToken,
      'expiryDateTime': expiryDateTime.toString(),
      'accessToken': accessToken,
      'userId': userId,
    };
  }
}