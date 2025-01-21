import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:market/models/purchase.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/user_service.dart';
import 'dio_service.dart';

final dio = DioClient().dio;


final class PurchaseService {
  factory PurchaseService() {
    return instance;
  }
  PurchaseService._internal();
  static final PurchaseService instance = PurchaseService._internal();

  late List<Purchase> _purchases;

  List<Purchase> get purchases => _purchases;


  Future<String> purchase(Purchase model) async{
    const url = 'https://farmers-api.runasp.net/api/purchases';
    for (var element in model.orders!) {
      element.address = model.address;
    }
    model.orders?.map((x) => x.offer = null).toList();
    print(jsonEncode(model));
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));
    await CartService.instance.clear();
    await UserService.instance.refresh();
    NotificationProvider().setOrders(UserService.instance.user.boughtOrders);
    return response.data;
  }

  List<Purchase> getPurchases(){
    return UserService.instance.user.boughtOrders;
  }

}
