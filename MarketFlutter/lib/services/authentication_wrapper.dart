import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/services/firebase_service.dart';
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
      //await storage.delete(key: "user_cart");
      //final String cartRead = await storage.read(key: "user_cart") ?? '[]';
      //List<dynamic> jsonData = jsonDecode(cartRead);
      List<Order> items = await FirebaseService.instance.getCart(UserService.instance.user.id) ?? [];

      CartService.instance.cart = items;
      await OfferService.instance.loadOffers();

      setState(() {
        isAuthenticated = true;
      });
    } catch (e) {
      print("Error during authentication: $e");
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
