import 'package:flutter/material.dart';

import '../models/order.dart';
class CartComponent extends StatelessWidget {
  final Order order;
  final BorderRadius borderRadius;
  final color;
  final textColor;
  const CartComponent({super.key, required this.order, required this.borderRadius, this.color = Colors.white, this.textColor = Colors.black});

  @override
  Widget build(BuildContext context, ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(1.0),
          child: Container(
            width: MediaQuery.of(context).size.width*0.9,
            height: MediaQuery.of(context).size.height*0.1,
            decoration: BoxDecoration(
              color: color,
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  spreadRadius: 0,
                  blurRadius: 15,
                  offset: Offset(5, 5), // Shadow moved to the right and bottom
                )
              ],
              borderRadius: borderRadius,
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("${order.quantity}KG of ${order.title.split(" ")[order.title.split(" ").length-1]}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: textColor, decoration: textColor == Colors.white ? TextDecoration.lineThrough : null),),
                        Text("${double.parse(order.price.toStringAsFixed(2))} BGN.", style: TextStyle(color: textColor,  decoration: textColor == Colors.white ? TextDecoration.lineThrough : null),),
                      ],
                    ),
                  )

                ],
              ),
            ),
          ),
        ),

      ],
    );
  }
}
