import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/shopping_list_item.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/services/user_service.dart';
import 'cart_service.dart';
import 'dio_service.dart';

/// Persistent storage for shopping list presets.
const storage = FlutterSecureStorage();

/// Singleton instance of Dio for HTTP requests.
final dio = DioClient().dio;

/// A service class to manage shopping list items and presets.
class ShoppingListService extends ChangeNotifier {
  /// Factory constructor to enforce singleton pattern.
  factory ShoppingListService() {
    return instance;
  }

  /// Private internal constructor for singleton implementation.
  ShoppingListService._internal();

  /// Singleton instance of `ShoppingListService`.
  static final ShoppingListService instance = ShoppingListService._internal();

  /// List of current shopping list items.
  List<ShoppingListItem> _items = [];

  /// Getter for shopping list items.
  List<ShoppingListItem> get items => _items;

  /// List of preset shopping list items.
  List<ShoppingListItem> _presets = [
    ShoppingListItem(title: "Baby Carrots", category: "Vegetables", type: "Carrots", quantity: 1.0),
    ShoppingListItem(title: "Iceberg Lettuce", category: "Vegetables", type: "Lettuce", quantity: 1.0),
    ShoppingListItem(title: "Red Potatoes", category: "Vegetables", type: "Potatoes", quantity: 1.0),
    ShoppingListItem(title: "Cherry Tomatoes", category: "Vegetables", type: "Tomatoes", quantity: 1.0),
    ShoppingListItem(title: "Red Apples", category: "Fruits", type: "Apples", quantity: 1.0),
    ShoppingListItem(title: "Cavendish Bananas", category: "Fruits", type: "Bananas", quantity: 1.0),
    ShoppingListItem(title: "Valencia Oranges", category: "Fruits", type: "Oranges", quantity: 1.0),
    ShoppingListItem(title: "Grass-Fed Beef Steak", category: "Meat", type: "Steak", quantity: 1.0),
    ShoppingListItem(title: "Sharp Cheddar Cheese", category: "Dairy", type: "Cheese", quantity: 1.0),
  ];

  /// Getter for preset shopping list items.
  List<ShoppingListItem> get presets => _presets;

  /// Deletes an item from the shopping list and saves changes.
  Future<void> delete(ShoppingListItem item) async {
    _items.remove(item);
    notifyListeners(); // Notify listeners about the change
    await saveData();
  }

  /// Edits an existing item in the shopping list and saves changes.
  Future<void> edit(ShoppingListItem old, ShoppingListItem updated) async {
    final index = items.indexWhere((item) => item.title == old.title);
    if (index != -1) {
      items[index] = updated;
      notifyListeners(); // Notify listeners about the change
      await saveData();
    } else {
      throw Exception('Item not found');
    }
  }

  /// Adds a new item to the shopping list and saves changes.
  Future<void> add(ShoppingListItem item) async {
    _items.add(item);
    notifyListeners(); // Notify listeners about the change
    await saveData();
  }

  /// Resets the shopping list by clearing all items.
  void reset() {
    _items = [];
    notifyListeners(); // Notify listeners about the change
  }

  /// Saves the current shopping list data to Firebase.
  Future<void> saveData() async {
    final data = {
      "key": UserService.instance.user.id,
      "data": _items.map((element) => element.toJson()).toList(),
    };
    FirebaseService.instance.saveData(data, "shopping_lists", UserService.instance.user.id);
  }

  /// Initializes the shopping list by loading data from Firebase and local storage.
  Future<void> init() async {
    // Load data from Firebase
    Map<String, dynamic>? data = await FirebaseService.instance.getData("shopping_lists", UserService.instance.user.id);
    List<dynamic> converted = data?["data"] ?? [];
    _items = converted.map((order) => ShoppingListItem.fromJson(order)).toList();

    // Load presets from local storage
    final String? savedPresets = await storage.read(key: "presets");
    if (savedPresets != null) {
      final List<dynamic> parsedJson = jsonDecode(savedPresets);
      _presets = parsedJson.map((item) => ShoppingListItem.fromJson(item)).toList();
    }
    notifyListeners(); // Notify listeners that initialization is complete
  }

  /// Adds a new preset item to the list of presets and saves it locally.
  Future<void> addPreset(ShoppingListItem newItem) async {
    _presets.add(newItem);
    notifyListeners(); // Notify listeners about the change
    await storage.write(key: "presets", value: jsonEncode(_presets));
  }

  /// Checks if a given item type is needed in the shopping list.
  bool isNeeded(String type) {
    return _items.any((x) => x.type == type);
  }

  /// Checks if a given title is already used in the shopping list.
  bool isTitleUsed(String title) {
    return _items.any((x) => x.title == title);
  }

  Future<void> update() async{
    var cart = CartService.instance.cart;
    for(var item in cart) {
      _items.firstWhere((x) => x.type == item.offerType!.name).quantity -= item.quantity;
      if(_items.firstWhere((x) => x.type == item.offerType!.name).quantity <= 0) {
        _items.remove(_items.firstWhere((x) => x.type == item.offerType!.name));
      }
    }
    await saveData();
  }
}
