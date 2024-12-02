import 'dart:io';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:market/services/user_service.dart';

final dio = Dio();

final class FirebaseService{
  factory FirebaseService() {
    instance.setupToken();
    return instance;
  }
  FirebaseService._internal();
  static final FirebaseService instance = FirebaseService._internal();

  final storage = FirebaseStorage.instance;

  Future<void> uploadFile(File? file, String path, String id) async {
    final Reference ref = storage.ref().child('${path}/${id}');
    await ref.putFile(file!);
  }

  Future<String> getImageLink(String path) async {
    final ref = storage.ref().child(path);
    return await ref.getDownloadURL();
  }

  Future setupToken() async{
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    FirebaseMessaging.instance.requestPermission();

    String? token = await messaging.getToken();
    String url = 'https://farmers-api.runasp.net/api/Users/setFirebaseToken?id=${UserService.instance.user.id}&token=$token';
    await dio.post(url);
  }




}
