import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:market/components/purchase_details_order_component.dart';

import '../components/cart_component.dart';
import '../models/purchase.dart';

class PurchaseDetails extends StatelessWidget {
  final Purchase purchase;
  const PurchaseDetails({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    // Localize date
    purchase.dateOrdered = purchase.dateOrdered!.toLocal();

    // Common text style for title/ID
    TextStyle commonTextStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black54,
      fontSize: 16,
    );

    // Common style for price
    TextStyle priceTextStyle = const TextStyle(
      fontWeight: FontWeight.w600,
      color: Colors.black87,
      fontSize: 18,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Align(alignment: Alignment.centerRight, child: Text("Purchase Details")),
        shadowColor: Colors.black87,
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // Column for date and purchase ID
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      DateFormat('EEE, d MMM').format(purchase.dateOrdered!),
                      style: commonTextStyle,
                    ),
                    Text(
                      "Purchase ID: ${purchase.id}",
                      style: commonTextStyle,
                    ),
                  ],
                ),
                Text(
                  "${purchase.price} BGN",
                  style: priceTextStyle,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Text("Status: ${purchase.isDelivered() ? "Delivered" : "In Progress"}"),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              itemCount: purchase.orders!.length,
              itemBuilder: (context, index) {
                // Determine border radius and color based on the order state
                BorderRadius borderRadius = (index == 0)
                    ? const BorderRadius.only(
                  topLeft: Radius.circular(10.0),
                  topRight: Radius.circular(10.0),
                )
                    : (index == purchase.orders!.length - 1)
                    ? const BorderRadius.only(
                  bottomLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                )
                    : BorderRadius.zero;

                Color color = Colors.white;
                Color textColor = Colors.black;
                if (purchase.orders![index].isDelivered) {
                  color = Colors.greenAccent;
                } else if (purchase.orders![index].isDenied!) {
                  color = Colors.black54;
                  textColor = Colors.white;
                }

                // Return the CartComponent for each order
                return PurchaseDetailsOrderComponent(
                  order: purchase.orders![index],
                  borderRadius: borderRadius,
                  width: MediaQuery.of(context).size.width - 30,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
