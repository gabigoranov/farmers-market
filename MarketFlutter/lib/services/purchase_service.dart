import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:market/models/purchase.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/services/user_service.dart';
import 'dio_service.dart';

/// Singleton instance of Dio for HTTP requests.
final dio = DioClient().dio;

/// A service class for handling purchases in the application.
final class PurchaseService {
  /// Factory constructor to enforce singleton pattern.
  factory PurchaseService() {
    return instance;
  }

  /// Private internal constructor for singleton implementation.
  PurchaseService._internal();

  /// Singleton instance of `PurchaseService`.
  static final PurchaseService instance = PurchaseService._internal();

  /// List of purchases made by the user.
  late List<Purchase> _purchases;

  /// Getter for the list of purchases.
  List<Purchase> get purchases => _purchases;

  /// Creates a new purchase by sending data to the API.
  ///
  /// - [model]: The `Purchase` object containing purchase details.
  /// - Returns: A `String` response from the API.
  Future<String> purchase(Purchase model) async {
    const url = 'https://api.freshly-groceries.com/api/purchases';

    // Set the address for each order in the purchase model.
    for (var element in model.orders!) {
      element.address = model.address;
    }

    // Clear the offer field for all orders in the model.
    model.orders?.map((x) => x.offer = null).toList();

    print(jsonEncode(model));

    // Send a POST request to create the purchase.
    Response<dynamic> response = await dio.post(url, data: jsonEncode(model));

    // Clear the user's cart and refresh their data.
    await ShoppingListService.instance.update();
    await CartService.instance.clear();
    await UserService.instance.refresh();

    // Update the notification provider with the user's purchased orders.
    NotificationProvider().setOrders(UserService.instance.user.boughtOrders);

    // Return the response data.
    return response.data;
  }

  /// Retrieves the list of purchases made by the user.
  ///
  /// - Returns: A list of `Purchase` objects.
  List<Purchase> getPurchases() {
    return UserService.instance.user.boughtOrders;
  }
}
