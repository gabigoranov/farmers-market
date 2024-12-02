import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:market/services/cart-service.dart';
import 'package:market/services/order_service.dart';
import 'package:market/services/user_service.dart';
import '../models/offer.dart';
import '../models/order.dart';
import '../models/purchase.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import '../services/purchase-service.dart';

const storage = FlutterSecureStorage();


class PurchaseView extends StatelessWidget {
  final Order model;
  final Offer offer;
  PurchaseView({super.key, required this.model, required this.offer});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Align(alignment: Alignment.centerRight, child: Text('Fill in the form')),
        shadowColor: Colors.black87,
        elevation: 0.4,
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _quantityController,
                    decoration: const InputDecoration(
                      labelText: 'Quantity in Kg',
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Enter a valid quantity!";
                      }
                      else if(double.parse(value) <= 0){
                        return "Quantity must be more than 0";
                      }
                      return null;
                    },
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  model.quantity = double.parse(_quantityController.value.text);
                                  model.price = double.parse((model.quantity*offer.pricePerKG).toStringAsFixed(2));
                                  model.offer = offer;
                                  model.title = offer.title;
                                  await CartService.instance.add(model);
                                  Navigator.pop(context);
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.blue,
                                shadowColor: Colors.black,
                                elevation: 4.0,
                              ),
                              child: Text("Add To Cart", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
