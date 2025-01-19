import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/loading.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/navigation.dart';
import 'package:market/views/onboarding.dart';

import '../models/order.dart';
import 'offer_service.dart';

const storage = FlutterSecureStorage();

class AuthenticationWrapper extends StatefulWidget {
  const AuthenticationWrapper({super.key});

  @override
  State<AuthenticationWrapper> createState() => _AuthenticationWrapperState();
}

class _AuthenticationWrapperState extends State<AuthenticationWrapper> {
  bool? isAuthenticated;
  @override
  void initState() {
    super.initState();
    authenticate();
  }

  Future<void> authenticate() async {
    try {
      await UserService.instance.refresh();
      FirebaseService.instance.setupToken();

      Map<String, dynamic> cartData = await FirebaseService.instance.getData("carts", UserService.instance.user.id) ?? {};
      List<dynamic> orders = cartData["orders"];

      List<Order> cart = orders.map((order) => Order.fromStorageJson(order)).toList();

      await ShoppingListService.instance.init();

      CartService.instance.cart = cart;
      await OfferService.instance.loadOffers();

      setState(() {
        isAuthenticated = true;
      });
    } catch (e) {

      setState(() {
        isAuthenticated = false; // Handle errors gracefully
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isAuthenticated == null) {
      return const Loading();
    } else if (isAuthenticated == true) {
      return const Navigation(index: 0);
    } else {
      return const Onboarding();
    }
  }
}
