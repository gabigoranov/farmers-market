import 'package:flutter/material.dart';
import 'package:market/services/purchase-service.dart';
import '../models/order.dart';
import '../models/purchase.dart';

class NotificationProvider with ChangeNotifier {
  static final NotificationProvider instance = NotificationProvider._internal();
  factory NotificationProvider() {
    instance.initOrders();
    return instance;
  }

  NotificationProvider._internal();


  List<Purchase> _orders = [];
  List<Purchase> get orders => _orders;

  void setOrders(List<Purchase> newOrders) {
    _orders = newOrders;
    notifyListeners();
  }

  void updateOrder(int id, String status) {
    initOrders();
    for(Purchase purchase in _orders){
      if(purchase.orders == null) continue;
      final index = purchase.orders!.indexWhere((order) => order.id == id);
      if (index != -1) {
        switch(status){
          case "accepted":
            _orders[_orders.indexWhere((x) => x.id == purchase.id)].orders![index].isAccepted = true;
            break;
          case "declined":
            _orders[_orders.indexWhere((x) => x.id == purchase.id)].orders![index].isDenied = true;
            break;
          case "delivered":
            _orders[_orders.indexWhere((x) => x.id == purchase.id)].orders![index].isDelivered = true;
            break;
        }
        notifyListeners();
      }
    }

  }

  void initOrders() {
    _orders = PurchaseService.instance.getPurchases();
  }

  Purchase getPurchase(int id) {
    initOrders();
    int index = _orders.indexWhere((x) => x.id == id);
    return _orders[index];
  }

}