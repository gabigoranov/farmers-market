import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/billing_details.dart';
import 'package:market/models/dto/jwt_refresh_response.dart';
import 'package:market/models/jwt_token.dart';
import 'package:market/models/user.dart';
import 'package:market/services/offer_service.dart';

import '../models/auth_model.dart';
import 'dio_service.dart';

final storage = FlutterSecureStorage();
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
    return await storage.read(key: 'jwt_token');
  }

  Future<void> saveToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  Future<void> login(String email, String password) async{

    String url = 'https://farmers-api.runasp.net/api/auth/login';
    AuthModel model = AuthModel(email: email, password: password);
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    print(response);

    User user =  User.fromJson(response.data);

    user.password = password;
    if(user.discriminator != 0){
      throw FormatException();
    }

    await storage.write(key: "user_data", value: jsonEncode([user.email, user.password]));
    _user = user;

    url = 'https://farmers-api.runasp.net/api/auth/refresh/${_user.id}';

    response = await dio.get(url);

    JwtRefreshResponse res = JwtRefreshResponse.fromJson(response.data);

    _user.refreshToken = res.refreshToken.refreshToken;
    _user.refreshTokenExpiryTime = DateTime.now().add(const Duration(days: 6));

    saveToken(res.accessToken);

  }

  Future<void> reload() async{
    const url = 'https://farmers-api.runasp.net/api/auth/login';
    AuthModel model = AuthModel(email: _user.email, password: _user.password);
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    String id = _user.password;
    User user =  User.fromJson(response.data);
    user.id = id;
    _user = user;
  }

  Future<User> getWithId(String id) async{
    final url = 'https://farmers-api.runasp.net/api/users/$id';
    Response<dynamic> response = await dio.get(url);
    User user =  User.fromJson(response.data);
    return user;
  }

  Future<int> postBillingDetails(BillingDetails model) async{
    const url = 'https://farmers-api.runasp.net/api/billing';
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    model.id =  int.parse(response.data.toString());

    _user.billingDetails ??= [];
    if(!_user.billingDetails!.any((x) => x.id == model.id)) //fix this maybe
    {
      _user.billingDetails!.add(model);
    }

    return model.id;
  }

  Future<String> delete(String id) async{
    final url = 'https://farmers-api.runasp.net/api/users/$id';
    Response<dynamic> response = await dio.delete(url);
    return response.data;
  }

  void logout() {
    storage.delete(key: "user_data");
    OfferService.instance.loadedOffers = [];
    OfferService.instance.offerWidgets = [];
  }

}
