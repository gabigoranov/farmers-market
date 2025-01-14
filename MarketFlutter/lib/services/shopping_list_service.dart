import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/offer.dart';
import 'package:market/models/shopping_list_item.dart';
import 'package:market/services/user_service.dart';

import '../components/offer_component.dart';
import 'dio_service.dart';

const storage = FlutterSecureStorage();
final dio = DioClient().dio;

final class ShoppingListService {
  factory ShoppingListService() {
    return instance;
  }
  ShoppingListService._internal();

  final List<ShoppingListItem> _items = [];
  List<ShoppingListItem> get items => _items;

  static final ShoppingListService instance = ShoppingListService._internal();


  Future<void> delete(int id) async{
    //delete specific item
  }

  Future<void> edit(int id) async{
    //edit specific item
  }

  Future<void> add(ShoppingListItem item) async{
    _items.add(item);
    //use firebase service to save data to firestore
  }
}
