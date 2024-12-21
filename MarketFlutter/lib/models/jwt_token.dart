


class JWTToken{
  String accessToken;
  String refreshToken;

  // Constructor
  JWTToken({required this.accessToken, required this.refreshToken});

  // Factory constructor to create a User instance from a JSON map
  factory JWTToken.fromJson(Map<String, dynamic> json) {
    JWTToken res = JWTToken(
      accessToken: json['accessToken'] as String,
      refreshToken: json['refreshToken'] as String,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}