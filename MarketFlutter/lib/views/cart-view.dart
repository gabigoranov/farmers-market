import 'dart:convert';
import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market/components/cart-component.dart';
import 'package:market/models/purchase.dart';
import 'package:market/services/cart-service.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/purchase-service.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/billing-details-view.dart';
import 'package:provider/provider.dart';
import '../models/order.dart';
import 'loading.dart';

class CartView extends StatefulWidget {

  CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final List<Order> items = CartService.instance.cart;

  bool isDisabled = false;

  void _removeItem(Order order) {
    setState(() {
      CartService.instance.delete(order);
    });
  }

  void _increaseQuantity(Order order, double quantity) {
    setState(() {
      CartService.instance.quantity(order, quantity);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Align(alignment: Alignment.centerRight, child: Text("Items in your cart")),
        shadowColor: Colors.black87,
        elevation: 0.4,
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
        child: Stack(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 1,
                  child: ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      BorderRadius borderRadius;
                      if (index == 0) {
                        borderRadius = const BorderRadius.only(
                          topLeft: Radius.circular(10.0),
                          topRight: Radius.circular(10.0),
                        );
                      } else if (index == items.length - 1) {
                        borderRadius = const BorderRadius.only(
                          bottomLeft: Radius.circular(10.0),
                          bottomRight: Radius.circular(10.0),
                        );
                      } else {
                        borderRadius = BorderRadius.zero;
                      }

                      return CartComponent(
                        order: items[index],
                        borderRadius: borderRadius,
                        onDelete: () => _removeItem(items[index]),
                        onIncrease: () => _increaseQuantity(items[index], 0.5),
                        onDecrease: () => _increaseQuantity(items[index], -0.5),
                      );
                    },
                  ),
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 150,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  color: Color(0xffFEFEFE),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54,
                      offset: Offset(
                      5.0,
                      5.0,
                    ),
                    blurRadius: 10.0,
                    spreadRadius: 2.0,
                    ), //BoxShadow
                    BoxShadow(
                      color: Colors.white,
                      offset: Offset(0.0, 0.0),
                      blurRadius: 0.0,
                      spreadRadius: 0.0,
                    ),
                  ],
                ),
                child: const Center(
                  child: PurchaseForm(),
                ),
              ),
            )
          ],
        ),
      )
    );
  }
}

class PurchaseForm extends StatefulWidget {
  const PurchaseForm({super.key});

  @override
  State<PurchaseForm> createState() => _PurchaseFormState();
}

class _PurchaseFormState extends State<PurchaseForm> {
  final List<Order> items = CartService.instance.cart;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _addressController = TextEditingController();
  bool isActive = true;


  void _disableButton() { setState(() { isActive = false; }); }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconButton(
                onPressed: () async{
                  await CartService.instance.clear();
                  Navigator.pop(
                    context,
                  );
                },
                icon: const Icon(Icons.delete),
              ),
              const SizedBox(width: 12,),
              SizedBox(
                width: 200,
                child: TextButton(
                  onPressed: isActive ? () async {
                    if(items.isEmpty) return;
                    Purchase purchase = Purchase(buyerId: UserService.instance.user.id, price: items.map((e) => e.price).sum, address: _addressController.text, orders: items);
                    Navigator.push(context, MaterialPageRoute(builder: (context) {return BillingDetailsView(purchase: purchase);}));
                  } : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff26D156),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 4.0,
                  ),
                  child: const Text("Purchase", style: TextStyle(color: Colors.white, fontSize: 24),),
                ),
              ),
              const SizedBox(width: 12,),
              Text("${double.parse((items.map((e) => e.price).sum).toStringAsFixed(2))}\nBGN."),
            ],
          ),
        ),
      ],
    );
  }
}
