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

const storage = FlutterSecureStorage();
final dio = DioClient().dio;

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

  Future<String?> getToken() async {
    return await storage.read(key: 'jwt');
  }

  Future<void> saveToken(Token token) async {
    await storage.write(key: 'jwt', value: jsonEncode(token));
  }

  Future<void> login(String email, String password) async{
    String url = 'https://farmers-api.runasp.net/api/auth/login';
    AuthModel model = AuthModel(email: email, password: password);
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    User user =  User.fromJson(response.data);

    if(user.discriminator != 0){
      throw const FormatException();
    }

    _user = user;
    await storage.write(key: 'jwt', value: jsonEncode(_user.token));
  }

  Future<List<Contact>> getAllContacts(List<String> contacts) async{
    const url = 'https://farmers-api.runasp.net/api/users/';
    Response<dynamic> response = await dio.post(url, data: jsonEncode(contacts));
    List<Contact> res = [];
    for(int i = 0; i < response.data.length; i++){
      res.add(Contact.fromJson(response.data[i]));

    }
    return res;
  }

  Future<void> refresh() async{
    const url = 'https://farmers-api.runasp.net/api/auth/refresh';
    final String? jwt = await storage.read(key: "jwt");
    if(jwt != null)
    {
      Token token = Token.fromJson(jsonDecode(jwt));
      var response = await dio.post(url, data: jsonEncode(token.refreshToken));
      User user = User.fromJson(response.data);
      await storage.write(key: "jwt", value: jsonEncode(user.token));
      _user = user;
    }
    else{
      throw Exception("Unauthorized");
    }
  }

  Future<User> getWithId(String id) async{
    final url = 'https://farmers-api.runasp.net/api/users/$id';
    Response<dynamic> response = await dio.get(url);
    User user =  User.fromJson(response.data);
    return user;
  }

  Future<Seller> getSellerWithId(String id) async{
    final url = 'https://farmers-api.runasp.net/api/users/seller/$id';

    Response<dynamic> response = await dio.get(url);


    Seller seller =  Seller.fromJson(response.data);

    return seller;
  }

  Future<int> postBillingDetails(BillingDetails model) async{
    const url = 'https://farmers-api.runasp.net/api/billing';
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    model.id =  int.parse(response.data.toString());

    _user.billingDetails ??= [];
    _user.billingDetails!.add(model);
    return model.id;
  }

  Future<String> delete(String id) async{
    final url = 'https://farmers-api.runasp.net/api/users/$id';
    Response<dynamic> response = await dio.delete(url);
    return response.data;
  }

  Future<void> logout() async{
    await storage.delete(key: "user_data");
    await storage.delete(key: "jwt");
    OfferService.instance.loadedOffers = [];
    OfferService.instance.offerWidgets = [];
  }

  Future deleteBillingDetails(int id) async{
    final url = 'https://farmers-api.runasp.net/api/billing/$id';
    await dio.delete(url);
    _user.billingDetails ??= [];
    _user.billingDetails!.removeWhere((x) => x.id == id);
  }

  Future editBillingDetails(int id, BillingDetails model) async{
    final url = 'https://farmers-api.runasp.net/api/billing/$id';
    await dio.put(url, data: jsonEncode(model));
    _user.billingDetails ??= [];
    _user.billingDetails![_user.billingDetails!.indexOf(_user.billingDetails!.singleWhere((x) => x.id == id))] = model;
  }
}
