import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/cart_item_component.dart';
import 'package:market/models/purchase.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/services/user_service.dart';
import '../models/order.dart';
import 'billing_details_screen.dart';
import 'package:market/l10n/app_localizations.dart';

class CartView extends StatefulWidget {

  const CartView({super.key});

  @override
  State<CartView> createState() => _CartViewState();
}

class _CartViewState extends State<CartView> {
  final List<Order> items = CartService.instance.cart;

  bool isDisabled = false;

  Future<void> _removeItem(Order order) async {
    setState(() {
      items.remove(order);
    });
    await CartService.instance.delete(order);
  }

  Future<void> _increaseQuantity(Order order, double quantity) async {
    setState(() {
      items[items.indexOf(order)].quantity += quantity;
    });
    items[items.indexOf(order)].quantity -= quantity;
    await CartService.instance.quantity(order, quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(alignment: Alignment.centerRight, child: Text(AppLocalizations.of(context)!.cart_app_bar)),
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

                      return CartItemComponent(
                        order: items[index],
                        borderRadius: borderRadius,
                        onDelete: () async => await _removeItem(items[index]),
                        onIncrease: () async => await _increaseQuantity(items[index], 0.5),
                        onDecrease: () async => await _increaseQuantity(items[index], -0.5),
                        width: MediaQuery.of(context).size.width * 0.92,
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
  final TextEditingController _addressController = TextEditingController();
  bool isActive = true;

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
                  Get.off(const CartView(), transition: Transition.fadeIn);
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
                    Get.to(BillingDetailsView(purchase: purchase), transition: Transition.fade);
                  } : () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff26D156),
                    foregroundColor: Colors.white,
                    shadowColor: Colors.black,
                    elevation: 4.0,
                  ),
                  child: Text(AppLocalizations.of(context)!.purchase, style: const TextStyle(color: Colors.white, fontSize: 24),),
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
