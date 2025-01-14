import 'package:flutter/material.dart';

import '../components/cart_component.dart';
import '../models/purchase.dart';

class PurchaseDetails extends StatelessWidget {
  final Purchase purchase;
  const PurchaseDetails({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Align(alignment: Alignment.centerRight, child: Text(purchase.isDelivered() ? "Delivered Purchase" : "Purchase in progress")),
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
                      itemCount: purchase.orders!.length,
                      itemBuilder: (context, index) {
                        BorderRadius borderRadius;
                        Color color = Colors.white;
                        Color textColor = Colors.black;
                        if (index == 0) {
                          borderRadius = const BorderRadius.only(
                            topLeft: Radius.circular(10.0),
                            topRight: Radius.circular(10.0),
                          );
                        } else if (index == purchase.orders!.length - 1) {
                          borderRadius = const BorderRadius.only(
                            bottomLeft: Radius.circular(10.0),
                            bottomRight: Radius.circular(10.0),
                          );
                        } else {
                          borderRadius = BorderRadius.zero;
                        }

                        if(purchase.orders![index].isDelivered){
                          color = Colors.greenAccent;
                        }else if(purchase.orders![index].isDenied!){
                          color = Colors.black54;
                          textColor = Colors.white;
                        }

                        return CartComponent(order: purchase.orders![index], borderRadius: borderRadius, color: color, textColor: textColor);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        )
    );
  }
}
