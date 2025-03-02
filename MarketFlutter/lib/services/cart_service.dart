import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/order.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/services/user_service.dart';

import 'dio_service.dart';

// Initialize secure storage for sensitive data (potentially unused in this snippet).
const storage = FlutterSecureStorage();
// Initialize Dio client for HTTP requests (potentially unused in this snippet).
final dio = DioClient().dio;

/// A service class for managing the shopping cart.
final class CartService {
  /// Private constructor to enforce singleton pattern.
  CartService._internal();

  /// Singleton instance of the CartService.
  static final CartService instance = CartService._internal();

  /// Factory constructor to access the singleton instance.
  factory CartService() {return instance;
  }

  /// List of orders in the cart.
  List<Order> cart = [];

  /// Adds an order to the cart.
  /// If the order already exists, it increases the quantity and price.
  /// Otherwise, it adds the order to the cart and updates Firestore.
  Future<void> add(Order order) async {
    int index = cart.indexWhere((element) => element.offerId == order.offerId);
    if (index >= 0) {
      cart[index].quantity += order.quantity;
      cart[index].price += order.price;
      return;
    }
    cart.add(order);
    await updateFirestore();
  }

  /// Clears the cart and updates Firestore.
  Future<void> clear() async {
    cart = [];
    await updateFirestore();
  }

  /// Updates the quantity of an order in the cart and updates Firestore.
  Future<void> quantity(Order order, double quantity) async {
    cart[cart.indexOf(order)].quantity += quantity;
    cart[cart.indexOf(order)].price =
        cart[cart.indexOf(order)].offer!.pricePerKG *
            cart[cart.indexOf(order)].quantity;
    if (cart[cart.indexOf(order)].quantity < 0.5) {
      cart[cart.indexOf(order)].quantity = 0.5;
    }
    await updateFirestore();
  }

  /// Deletes an order from the cart and updates Firestore.
  Future<void> delete(Order order) async {
    cart.remove(order);
    await updateFirestore();
  }

  /// Updates the cart data in Firestore.
  Future<void> updateFirestore() async {
    final data = {
      "key": UserService.instance.user.id,
      "orders": cart.map((element) => element.toJson()).toList(),
    };
    await FirebaseService.instance.saveData(
        data, "carts", UserService.instance.user.id);
  }
}