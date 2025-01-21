


class AuthModel{
  String email;
  String password;

  // Constructor
  AuthModel({required this.email, required this.password});

  // Factory constructor to create a User instance from a JSON map
  factory AuthModel.fromJson(Map<String, dynamic> json) {
    AuthModel res = AuthModel(
      email: json['email'] as String,
      password: json['password'] as String,
    );
    return res;
  }

  // Method to convert User instance to a JSON map
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
    };
  }
}