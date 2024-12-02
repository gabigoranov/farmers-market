import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/order.dart';
import 'package:market/models/user.dart';

final storage = FlutterSecureStorage();
final dio = Dio();

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
    int index = cart.indexWhere((element) => element.offer!.id == order.offer!.id);
    if(index >= 0){
      cart[index].quantity += order.quantity;
      cart[index].price += order.price;
      return;
    }
    cart.add(order);
    await storage.write(key: "user_cart", value: jsonEncode(cart));
  }

  Future<void> delete() async{
    await storage.write(key: "user_cart", value: jsonEncode([]));
    cart = [];
  }



}
