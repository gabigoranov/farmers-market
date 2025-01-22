import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/services/shopping_list_service.dart';
import 'package:market/views/loading_screen.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/bottom_navigation_view.dart';
import 'package:market/views/onboarding_screen.dart';

import '../models/order.dart';
import '../services/locale_service.dart';
import '../services/offer_service.dart';

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
      //await storage.delete(key: "jwt");
      await LocaleService.instance.init();


      await UserService.instance.refresh();
      await FirebaseService.instance.setupToken();

      print("setup firebase token");

      Map<String, dynamic> cartData = await FirebaseService.instance.getData("carts", UserService.instance.user.id) ?? {};
      print("got cart data");
      List<dynamic> orders = cartData["orders"] ?? [];
      print("parsed cd 1");
      List<Order> cart = orders.map((order) => Order.fromStorageJson(order)).toList();
      print("parsed cd 2");


      await ShoppingListService.instance.init();
      print("init sls");

      CartService.instance.cart = cart;

      await OfferService.instance.loadOffers();

      print("loaded offers");

      setState(() {
        isAuthenticated = true;
      });
    } catch (e) {
      print("EEEEEEEEEEEEEEEEEERRRRRRRRRRRRRRRRRRRRRRRROR");
      print(e);
      setState(() {
        isAuthenticated = false;
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
