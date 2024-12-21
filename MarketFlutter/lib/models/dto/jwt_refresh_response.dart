
import '../token.dart';


class JwtRefreshResponse{
  Token refreshToken;
  String accessToken;

  JwtRefreshResponse({required this.refreshToken, required this.accessToken});

  factory JwtRefreshResponse.fromJson(Map<String, dynamic> json) {
    JwtRefreshResponse res = JwtRefreshResponse(
      refreshToken: Token.fromJson(json['refreshToken']),
      accessToken: json['accessToken'] as String,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'refreshToken': refreshToken.toJson(),
      'accessToken': accessToken,
    };
  }
}