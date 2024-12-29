import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market/services/user_service.dart';

import '../models/purchase.dart';
import '../models/order.dart' as order_model;
import 'dio_service.dart';

final dio = DioClient().dio;


final class FirebaseService{
  factory FirebaseService() {
    instance.setupToken();
    return instance;
  }
  FirebaseService._internal();
  static final FirebaseService instance = FirebaseService._internal();

  final storage = FirebaseStorage.instance;
  final firestore = FirebaseFirestore.instance;

  Future<void> uploadFile(File? file, String path, String id) async {
    final Reference ref = storage.ref().child('$path/$id');
    await ref.putFile(file!);
  }

  Future<String> getImageLink(String path) async {
    print(path);
    final ref = storage.ref().child(path);
    final res = await ref.getDownloadURL();
    return res;
  }

  Future setupToken() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging.instance.requestPermission();

    String? token = await messaging.getToken();
    String url = 'https://farmers-api.runasp.net/api/firebase/token/${UserService.instance.user.id}';
    await dio.post(url, data: jsonEncode(token));

  }

  Future<void> saveCart(List<order_model.Order> cart, String buyerId) async {
    try {
      await firestore.collection("carts").doc(buyerId).set({
        "userId": buyerId,
        "orders": cart.map((element) => element.toJson()).toList(),
      });
      print("Cart saved");
    } catch(e) {
      print("error saving cart $e");
    }
  }

  Future<List<order_model.Order>?> getCart(String userId) async {
    try {
      final doc = await firestore.collection("carts").doc(userId).get();
      if(doc.exists) {
        final data = doc.data();
        if(data != null && data["orders"] != null){
          final orders = (data["orders"] as List).map((order) => order_model.Order.fromStorageJson(order)).toList();
          return orders;
        }
      } else {
        print("No cart found for user $userId");
      }
    } catch(e) {
      print("Error retrieving cart: $e");
    }
    return null;
  }
}
