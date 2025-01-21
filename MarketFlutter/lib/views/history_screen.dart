import 'package:flutter/material.dart';
import 'package:market/components/history_item_component.dart';
import 'package:market/services/purchase_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/purchase.dart';
import '../providers/notification_provider.dart';

class History extends StatefulWidget {

  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Purchase> orders = PurchaseService.instance.getPurchases();

  List<HistoryItemComponent> widgets = [];

  void reloadWidgets() {
    orders = orders.reversed.toList();
    widgets = List.generate(orders.length, (index) {
      final borderRadius = BorderRadius.only(
        topLeft: Radius.circular(index == 0 ? 25 : 0),
        topRight: Radius.circular(index == 0 ? 25 : 0),
        bottomLeft: Radius.circular(index == orders.length - 1 ? 25 : 0),
        bottomRight: Radius.circular(index == orders.length - 1 ? 25 : 0),
      );
      return HistoryItemComponent(order: orders[index], borderRadius: borderRadius);
    });
  }

  @override
  void initState() {
    super.initState();
    orders = PurchaseService.instance.getPurchases();
    reloadWidgets();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<NotificationProvider>(
      builder: (BuildContext context, NotificationProvider notificationProvider, Widget? child) {
        orders = notificationProvider.orders;
        reloadWidgets();
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Align(alignment: Alignment.center, child: Text(AppLocalizations.of(context)!.order_history, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),)),
            shadowColor: Colors.black87,
            elevation: 0.4,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
          ),
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10 , horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.9,
                    child: Column(
                      children: widgets.toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );

  }
}

