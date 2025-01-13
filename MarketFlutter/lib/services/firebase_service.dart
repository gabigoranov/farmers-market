import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market/models/message.dart';
import 'package:market/services/user_service.dart';
import 'package:googleapis_auth/auth_io.dart';
import '../models/purchase.dart';
import '../models/order.dart' as order_model;
import 'package:flutter/services.dart' show rootBundle;
import '../providers/notification_provider.dart';
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
  final fcm = FirebaseMessaging.instance;

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
    await postToken(token);
  }

  Future postToken(String? token) async{
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

  Future<void> saveChats(Map<String, List<Message>> chats, String userId) async {
    try {
      Map<String, dynamic> encodedChats = chats.map((key, messages) {
        return MapEntry(
          key,
          messages.map((message) => message.toJson()).toList(),
        );
      });
      await firestore.collection("chats").doc(userId).set(encodedChats);
      print("Messages saved");
    } catch(e) {
      print("error saving chats $e");
    }
  }

  Future<Map<String, List<Message>>> getChats(String userId) async {
    try {
      DocumentSnapshot snapshot = await firestore.collection("chats").doc(userId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        return data.map((key, messages) {
          return MapEntry(
            key,
            (messages as List<dynamic>)
                .map((message) => Message.fromJson(message as Map<String, dynamic>))
                .toList(),
          );
        });
      }

      return {};
    } catch (e) {
      print("Error loading chats: $e");
      return {};
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

  Future<void> sendMessage(String toToken, String title, String body, String senderId, String recipientId) async {
    const String serverKey = '0cdca6dab517f9d11ecc3ae938ea8cdc4f89b564';
    const String fcmUrl = 'https://fcm.googleapis.com/v1/projects/market-229ca/messages:send';

    // Obtain the OAuth 2.0 access token using the server key
    final accessToken = await getAccessToken(serverKey);

    if(toToken.isEmpty){
      return;
    }

    final Map<String, dynamic> message = {
      'message': {
        'token': toToken,
        'notification': {
          'title': title,
          'body': body,
        },
        'data': {
          'type': "message",
          'senderId': senderId,
          'recipientId': recipientId,
          'timestamp': DateTime.timestamp().toString(),
        }
      },
    };

    final client = Dio();
    final response = await client.post(
      fcmUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
      data: json.encode(message),
    );
  }

  Future<String> getAccessToken(String serverKey) async {
    // Load the firebase key file as a string from assets
    final firebaseKeyJson = await rootBundle.loadString('assets/firebase-key.json');
    // Parse the JSON content
    final serviceAccountCredentials = ServiceAccountCredentials.fromJson(firebaseKeyJson);
    final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
    final client = await clientViaServiceAccount(serviceAccountCredentials, scopes);
    final accessToken = client.credentials.accessToken;
    return accessToken.data;
  }

  Map<String, List<Message>> getMessages() {
    return {};
  }



}
