import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:market/models/purchase.dart';
import 'package:market/models/user.dart';
import 'package:market/services/cart-service.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/user_service.dart';
import '../models/order.dart';

final dio = Dio();

final class PurchaseService {
  factory PurchaseService() {
    return instance;
  }
  PurchaseService._internal();
  static final PurchaseService instance = PurchaseService._internal();

  late List<Purchase> _purchases;

  List<Purchase> get purchases => _purchases;


  Future<String> purchase(Purchase model) async{
    const url = 'https://farmers-api.runasp.net/api/Purchases/add/';
    Response<dynamic> response = await dio.post(url, data: model.toJson());
    await CartService.instance.delete();
    UserService.instance.reload();
    NotificationProvider().setOrders(UserService.instance.user.boughtOrders);
    return response.data;
  }

  List<Purchase> getPurchases(){
    return UserService.instance.user.boughtOrders;
  }

}
