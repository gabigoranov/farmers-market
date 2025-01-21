import 'dart:convert';

import 'package:flutter/material.dart';
import '../models/order.dart';
import '../services/offer_type_service.dart';
import '../services/shopping_list_service.dart';

class PurchaseDetailsOrderComponent extends StatefulWidget {
  final Order order;
  final BorderRadius borderRadius;
  final double width;

  const PurchaseDetailsOrderComponent({
    super.key,
    required this.order,
    required this.borderRadius,
    required this.width,
  });

  @override
  State<PurchaseDetailsOrderComponent> createState() => _PurchaseDetailsOrderComponentState();
}

class _PurchaseDetailsOrderComponentState extends State<PurchaseDetailsOrderComponent> {
  @override
  Widget build(BuildContext context) {
    print(jsonEncode(widget.order));
    return GestureDetector(
      child: Container(
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              spreadRadius: 0,
              blurRadius: 15,
              offset: Offset(5, 5), // Shadow moved to the right and bottom
            ),
          ],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: OfferTypeService.instance.getColor(widget.order.offerType!.name),
                  borderRadius: BorderRadius.circular(50),
                  boxShadow: const[
                    BoxShadow(
                      color: Colors.black12,
                      spreadRadius: 0,
                      blurRadius: 15,
                      offset: Offset(5, 5), // Shadow moved to the right and bottom
                    ),
                  ],
                ),
                child: Center(child: OfferTypeService.instance.getIcon(widget.order.offerType!.name)),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(widget.order.title, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Theme.of(context).colorScheme.tertiary),),
                  Text("${widget.order.price / widget.order.quantity}lv/kg ") //TODO: add town to user class (update api and db)
                ],
              ),
            ],
          ),
        ),
      ),
      onTap: (){
        //expand
      },
    );
  }
}
