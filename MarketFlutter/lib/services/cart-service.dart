import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/order.dart';
import 'package:market/models/user.dart';

import 'dio_service.dart';

final storage = FlutterSecureStorage();
final dio = DioClient().dio;

final class CartService {
  factory CartService() {
    return instance;
  }

  CartService._internal();

  static final CartService instance = CartService._internal();

  List<Order> cart = [];




  Future<void> add(Order order) async{
    String? read = await storage.read(key: "user_cart");
    if(read == null){
      await storage.write(key: "user_cart", value: jsonEncode([order]));
      cart = [order];
      return;
    }
    int index = cart.indexWhere((element) => element.offerId == order.offerId);
    if(index >= 0){
      cart[index].quantity += order.quantity;
      cart[index].price += order.price;
      return;
    }
    cart.add(order);
    await storage.write(key: "user_cart", value: jsonEncode(cart));
  }

  Future<void> clear() async{
    await storage.write(key: "user_cart", value: jsonEncode([]));
    cart = [];
  }

  void quantity(Order order, double quantity) {
    cart[cart.indexOf(order)].quantity += quantity;
    cart[cart.indexOf(order)].price = cart[cart.indexOf(order)].offer!.pricePerKG * cart[cart.indexOf(order)].quantity;
    if(cart[cart.indexOf(order)].quantity < 0.5) cart[cart.indexOf(order)].quantity = 0.5;
  }

  void delete(Order order) {
    cart.remove(order);
  }




}
