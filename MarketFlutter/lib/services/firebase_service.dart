import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market/services/user_service.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:flutter/services.dart' show rootBundle;
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

  /// Upload file to specified path in firebase storage.
  Future<void> uploadFile(File? file, String path, String id) async {
    final Reference ref = storage.ref().child('$path/$id');
    await ref.putFile(file!);
  }

  /// Get the URI of an image found in the specified firebase storage path.
  Future<String> getImageLink(String path) async {
    final ref = storage.ref().child(path);
    final res = await ref.getDownloadURL();
    return res;
  }

  /// Get FirebaseMessaging token.
  Future setupToken() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    //Request notification permission before setup.
    FirebaseMessaging.instance.requestPermission();

    String? token = await messaging.getToken();
    await postToken(token);
  }

  /// Post String FM token to API.
  Future postToken(String? token) async{
    String url = 'https://api.freshly-groceries.com/api/firebase/token/${UserService.instance.user.id}';
    await dio.post(url, data: jsonEncode(token));
  }

  /// Save dynamic data to a specified location in Firestore Database.
  Future<void> saveData(dynamic data, String collection, String key) async {
    try {
      await firestore.collection(collection).doc(key).set(data);
    }
    catch(e) {
      print("An error occurred while saving data to firestore: $e");
    }
  }

  /// Get data from Firestore as JSON.
  Future<Map<String, dynamic>?> getData(String collection, String key) async {
    try {
      final doc = await firestore.collection(collection).doc(key).get();
      if(doc.exists) {
        final data = doc.data();
        if(data != null) {
          return data;
        }
      }
    } catch(e) {
      print("An error occurred while getting data from firestore: $e");
    }
    return null;
  }

  /// Sends message via Firebase Messaging to the user with the specified FM token.
  Future<void> sendMessage(String toToken, String title, String body, String senderId, String recipientId) async {
    const String serverKey = '0cdca6dab517f9d11ecc3ae938ea8cdc4f89b564';
    const String fcmUrl = 'https://fcm.googleapis.com/v1/projects/market-229ca/messages:send';

    // Obtain the OAuth 2.0 access token using the server key.
    final accessToken = await getAccessToken(serverKey);
    print(accessToken);
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

    print(message);

    final client = Dio();
    print("about to post");
    await client.post(
      fcmUrl,
      options: Options(
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
      ),
      data: json.encode(message),
    );
    print("sent");
  }

  /// Get OAuth 2.0 token used for FCM
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
}
