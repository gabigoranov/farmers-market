import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market/models/purchase.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/views/finalize_purchase_screen.dart';
import 'package:provider/provider.dart';

class HistoryItemComponent extends StatefulWidget {
  final Purchase order;
  final BorderRadius borderRadius; // Added borderRadius parameter

  const HistoryItemComponent({
    super.key,
    required this.order,
    required this.borderRadius, // Constructor now accepts borderRadius
  });

  @override
  State<HistoryItemComponent> createState() => _HistoryItemComponentState();
}

class _HistoryItemComponentState extends State<HistoryItemComponent> {
  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (BuildContext context, NotificationProvider notificationProvider, Widget? child) {
        Purchase order = notificationProvider.getPurchase(widget.order.id);

        buildInnerContents() {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        DateFormat("dd/MM/yy").format(order.dateOrdered!).toString(),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "${order.address}",
                            style: const TextStyle(color: Colors.black),
                          ),
                          const SizedBox(width: 22),
                          Text(
                            "${order.price.toStringAsFixed(2)} BGN.",
                            style: const TextStyle(color: Colors.black),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          child: Container(
            margin: const EdgeInsets.fromLTRB(0, 10, 0, 0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.1,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(5, 5), // Shadow moved to the right and bottom
                          ),
                        ],
                        borderRadius: widget.borderRadius, // Apply borderRadius here
                      ),
                    ),
                    Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: order.orders!
                            .where((x) => x.isDelivered == true)
                            .length /
                            order.orders!.length,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: widget.borderRadius, // Apply borderRadius here
                            color: Colors.greenAccent, // Fill color
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment.centerRight,
                        widthFactor: order.orders!
                            .where((x) => x.isDenied == true)
                            .length /
                            order.orders!.length,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: widget.borderRadius, // Apply borderRadius here
                            color: Colors.red, // Fill color
                          ),
                        ),
                      ),
                    ),
                    buildInnerContents(),
                  ],
                ),
              ],
            ),
          ),
          onTap: () {
            Get.to(PurchaseDetails(purchase: order), transition: Transition.fade);
          },
        );
      },
    );
  }
}
