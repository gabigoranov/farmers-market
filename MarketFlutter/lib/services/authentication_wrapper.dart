import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/models/user.dart';
import 'package:market/services/cart-service.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/views/landing.dart';
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
  bool isAuthenticated = false;
  Future<void> authenticate() async{
    final String? read = await storage.read(key: "user_data");
    if(read != null){
      final json = await jsonDecode(read);
      await UserService.instance.login(json[0], json[1]); //maybe remove
      isAuthenticated = true;
    }
    final String cartRead = await storage.read(key: "user_cart") ?? '';
    List<dynamic> jsonData = jsonDecode(cartRead);
    List<Order> items = jsonData.map((orderJson) => Order.fromStorageJson(orderJson)).toList();
    CartService.instance.cart = items;
    OfferService.instance.loadOffers();

    FirebaseService.instance.setupToken();


  }

  @override
  Widget build(BuildContext context){
    return FutureBuilder(future: authenticate(),
      builder: (context, snapshot){
        if(snapshot.connectionState == ConnectionState.waiting){
          return Loading();
        }
        else if(isAuthenticated){
          return const Navigation(index: 0,);
        }

        return const Onboarding();
      },
    );
  }
}
