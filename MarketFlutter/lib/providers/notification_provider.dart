import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/services/purchase_service.dart';
import 'package:market/services/user_service.dart';
import '../models/message.dart';
import '../models/purchase.dart';

class NotificationProvider with ChangeNotifier {
  static final NotificationProvider instance = NotificationProvider._internal();
  factory NotificationProvider() {
    instance.init();
    return instance;
  }

  NotificationProvider._internal();


  List<Purchase> _orders = [];
  List<Purchase> get orders => _orders;
  Map<String, List<Message>> _messages = {};
  Map<String, List<Message>> get messages => _messages;

  void setOrders(List<Purchase> newOrders) {
    _orders = newOrders;
    notifyListeners();
  }

  void setMessages(Map<String, List<Message>> newMessages) {
    _messages = newMessages;
    notifyListeners();
  }


  void updateOrder(int id, String status) {
    _orders = PurchaseService.instance.getPurchases();
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

  Future<void> addMessage(Message message, bool isReceived) async {
    print(jsonEncode(message));
    // Determine the key based on whether the message is received or sent
    var key = isReceived ? message.senderId : message.recipientId;
    // Initialize the list for the key if it doesn't exist
    _messages[key] ??= [];
    // Add the message to the corresponding list
    _messages[key]!.add(message);
    notifyListeners();
    await FirebaseService.instance.saveChats(_messages, UserService.instance.user.id);

  }

  Future<void> init() async{
    _orders = PurchaseService.instance.getPurchases();
    _messages = await FirebaseService.instance.getChats(UserService.instance.user.id);
  }

  Purchase getPurchase(int id) {
    _orders = PurchaseService.instance.getPurchases();
    int index = _orders.indexWhere((x) => x.id == id);
    return _orders[index];
  }

  Future<void> addContact(String ownerId) async{
    if(_messages[ownerId] != null){
      return;
    }

    _messages[ownerId] ??= [];
    notifyListeners();
    await FirebaseService.instance.saveChats(_messages, UserService.instance.user.id);
  }

}