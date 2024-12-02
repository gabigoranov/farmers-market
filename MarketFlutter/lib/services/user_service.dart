import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/user.dart';
import 'package:market/services/offer_service.dart';

final storage = FlutterSecureStorage();
final dio = Dio();

final class UserService {
  factory UserService() {
    return instance;
  }

  UserService._internal();

  static final UserService instance = UserService._internal();

  late User _user;

  User get user => _user;

  void setUser(User user) {
    _user = user;
  }

  Future<void> login(String email, String password) async{
    final url = 'https://farmers-api.runasp.net/api/users/login?email=$email&password=$password';
    Response<dynamic> response = await dio.get(url);

    User user =  User.fromJson(response.data);
    if(user.discriminator != 0){
      throw FormatException();
    }

    await storage.write(key: "user_data", value: jsonEncode([user.email, user.password]));
    _user = user;

  }

  Future<void> reload() async{
    final url = 'https://farmers-api.runasp.net/api/Users/login?email=${this.user.email}&password=${this.user.password}';
    Response<dynamic> response = await dio.get(url);
    User user =  User.fromJson(response.data);
    _user = user;
  }

  Future<User> getWithId(String id) async{
    final url = 'https://farmers-api.runasp.net/api/Users/getWithId?id=$id';
    Response<dynamic> response = await dio.get(url);
    User user =  User.fromJson(response.data);
    return user;
  }

  Future<String> delete(String id) async{
    final url = 'https://farmers-api.runasp.net/api/Users/delete?id=$id';
    print(url);
    Response<dynamic> response = await dio.delete(url);
    return response.data;
  }

  void logout() {
    storage.delete(key: "user_data");
    OfferService.instance.loadedOffers = [];
    OfferService.instance.offerWidgets = [];
  }

}
