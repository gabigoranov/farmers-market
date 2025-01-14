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

  final List<ShoppingListItem> _presets = [
    // Vegetables
    ShoppingListItem(title: "Baby Carrots", category: "Vegetables", type: "Carrots", quantity: 1.0),
    ShoppingListItem(title: "Iceberg Lettuce", category: "Vegetables", type: "Lettuce", quantity: 1.0),
    ShoppingListItem(title: "Red Potatoes", category: "Vegetables", type: "Potatoes", quantity: 1.0),
    ShoppingListItem(title: "Cherry Tomatoes", category: "Vegetables", type: "Tomatoes", quantity: 1.0),

    // Fruits
    ShoppingListItem(title: "Red Apples", category: "Fruits", type: "Apples", quantity: 1.0),
    ShoppingListItem(title: "Cavendish Bananas", category: "Fruits", type: "Bananas", quantity: 1.0),
    ShoppingListItem(title: "Valencia Oranges", category: "Fruits", type: "Oranges", quantity: 1.0),

    // Meat
    ShoppingListItem(title: "Grass-Fed Beef Steak", category: "Meat", type: "Steak", quantity: 1.0),

    // Dairy
    ShoppingListItem(title: "Sharp Cheddar Cheese", category: "Dairy", type: "Cheese", quantity: 1.0),
  ];

  List<ShoppingListItem> get presets => _presets;


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
