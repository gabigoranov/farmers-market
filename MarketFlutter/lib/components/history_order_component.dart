import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market/models/purchase.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/views/purchase–details.dart';
import 'package:provider/provider.dart';

class HistoryOrderComponent extends StatefulWidget {
  final Purchase order;
  const HistoryOrderComponent({super.key, required this.order});

  @override
  State<HistoryOrderComponent> createState() => _HistoryOrderComponentState();
}

class _HistoryOrderComponentState extends State<HistoryOrderComponent> {


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (BuildContext context, NotificationProvider notificationProvider, Widget? child) {
        Purchase order = notificationProvider.getPurchase(widget.order.id);
        return GestureDetector(
          onTap: () {
            Get.to(PurchaseDetails(purchase: order), transition: Transition.fade);
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(5.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height*0.1,
                      width: MediaQuery.of(context).size.width*0.9,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 0,
                            blurRadius: 15,
                            offset: Offset(5, 5), // Shadow moved to the right and bottom
                          )
                        ],
                        borderRadius: BorderRadius.circular(25),
                      ),
                    ),
                    Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: order.orders!.where((x) => x.isDelivered == true).length/order.orders!.length,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.greenAccent, // Fill color
                          ),
                        ),
                      ),
                    ),
                    Positioned.fill(
                      child: FractionallySizedBox(
                        alignment: Alignment.centerRight,
                        widthFactor: order.orders!.where((x) => x.isDenied == true).length/order.orders!.length,
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.red, // Fill color
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(DateFormat("dd/MM/yy").format(order.dateOrdered!).toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Colors.black),),
                                Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text("${order.address}", style: const TextStyle(color: Colors.black),),
                                    const SizedBox(width:  22,),
                                    Text("${order.price.toStringAsFixed(2)} BGN.", style: const TextStyle(color: Colors.black)),
                                  ],
                                ),
                              ],
                            ),
                          )

                        ],
                      ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        );
      },
    );

  }
}
