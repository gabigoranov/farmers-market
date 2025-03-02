import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/billing_details.dart';
import 'package:market/models/user.dart';
import 'package:market/services/offer_service.dart';

import '../models/dto/contact.dart';
import '../models/seller.dart';
import '../models/dto/auth_model.dart';
import '../models/token.dart';
import 'dio_service.dart';

/// Persistent storage for token and user data.
const storage = FlutterSecureStorage();

/// Singleton instance of Dio for HTTP requests.
final dio = DioClient().dio;

/// A service class for managing user authentication, user details, and billing details.
final class UserService {
  /// Factory constructor to enforce singleton pattern.
  factory UserService() {
    return instance;
  }

  /// Private internal constructor for singleton implementation.
  UserService._internal();

  /// Singleton instance of `UserService`.
  static final UserService instance = UserService._internal();

  /// Private variable to store user details.
  late User _user;

  /// Getter for user details.
  User get user => _user;

  /// Sets the user instance.
  void setUser(User user) {
    _user = user;
  }

  /// Retrieves the stored JWT token.
  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  /// Saves the JWT token in secure storage.
  Future<void> saveToken(Token token) async {
    await storage.write(key: 'jwt', value: jsonEncode(token));
  }

  /// Logs in the user using email and password.
  /// Throws a [FormatException] if the user discriminator is not 0 (indicating a seller or admin).
  Future<void> login(String email, String password) async {
    const url = 'https://api.freshly-groceries.com/api/auth/login';
    AuthModel model = AuthModel(email: email, password: password);
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    User user = User.fromJson(response.data);

    if (user.discriminator != 0) {
      throw const FormatException();
    }

    _user = user;
    await storage.write(key: 'jwt', value: jsonEncode(_user.token));
  }

  /// Retrieves a list of [Contact] objects by their IDs.
  Future<List<Contact>> getAllContacts(List<String> contacts) async {
    const url = 'https://api.freshly-groceries.com/api/users/';
    Response<dynamic> response = await dio.post(url, data: jsonEncode(contacts));
    return response.data.map<Contact>((json) => Contact.fromJson(json)).toList();
  }

  /// Refreshes the user session by refreshing the token.
  Future<void> refresh() async {
    const url = 'https://api.freshly-groceries.com/api/auth/refresh';
    final String? jwt = await storage.read(key: "jwt");
    if (jwt != null) {
      Token token = Token.fromJson(jsonDecode(jwt));
      var response = await dio.post(url, data: jsonEncode(token.refreshToken));
      User user = User.fromJson(response.data);
      await storage.write(key: "jwt", value: jsonEncode(user.token));
      _user = user;
    } else {
      throw Exception("Unauthorized");
    }
  }

  /// Retrieves a user by their ID.
  Future<User> getWithId(String id) async {
    final url = 'https://api.freshly-groceries.com/api/users/$id';
    Response<dynamic> response = await dio.get(url);
    return User.fromJson(response.data);
  }

  /// Retrieves a seller by their ID.
  Future<Seller> getSellerWithId(String id) async {
    final url = 'https://api.freshly-groceries.com/api/users/seller/$id';
    Response<dynamic> response = await dio.get(url);
    return Seller.fromJson(response.data);
  }

  /// Posts billing details for the user and updates the user instance.
  Future<int> postBillingDetails(BillingDetails model) async {
    const url = 'https://api.freshly-groceries.com/api/billing';
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    model.id = int.parse(response.data.toString());

    _user.billingDetails ??= [];
    _user.billingDetails!.add(model);
    return model.id;
  }

  /// Deletes a user by their ID.
  Future<String> delete(String id) async {
    final url = 'https://api.freshly-groceries.com/api/users/$id';
    Response<dynamic> response = await dio.delete(url);
    return response.data;
  }

  /// Logs out the user by clearing stored data and resetting related services.
  Future<void> logout() async {
    await storage.delete(key: "user_data");
    await storage.delete(key: "jwt");
    OfferService.instance.loadedOffers = [];
    OfferService.instance.offerWidgets = [];
  }

  /// Deletes billing details by ID.
  Future<void> deleteBillingDetails(int id) async {
    final url = 'https://api.freshly-groceries.com/api/billing/$id';
    await dio.delete(url);
    _user.billingDetails?.removeWhere((x) => x.id == id);
  }

  /// Edits billing details by ID.
  Future<void> editBillingDetails(int id, BillingDetails model) async {
    final url = 'https://api.freshly-groceries.com/api/billing/$id';
    await dio.put(url, data: jsonEncode(model));
    if (_user.billingDetails != null) {
      int index = _user.billingDetails!.indexWhere((x) => x.id == id);
      if (index != -1) {
        _user.billingDetails![index] = model;
      }
    }
  }
}
