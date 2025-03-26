import 'dart:io';
import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/firebase_service.dart';
import '../services/user_service.dart';

class ImageFileProvider with ChangeNotifier {
  static final ImageFileProvider instance = ImageFileProvider._internal();
  factory ImageFileProvider() {
    return instance;
  }

  ImageFileProvider._internal();


  File? _selected;
  File? get selected => _selected;


  void select(File file) {
    _selected = file;
    notifyListeners();
  }

  Future<void> uploadProfileImage() async{
    if(selected == null) return;
    User userData = UserService.instance.user;
    final uploader = FirebaseService();
    uploader.uploadFile(_selected, "profiles", userData.email);
  }

}