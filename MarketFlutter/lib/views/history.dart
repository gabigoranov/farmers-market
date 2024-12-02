import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:market/components/history_order_component.dart';
import 'package:market/services/purchase-service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../models/purchase.dart';
import '../services/notification_service.dart';

class History extends StatefulWidget {

  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Purchase> orders = PurchaseService.instance.getPurchases();

  List<HistoryOrderComponent> widgets = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    for(int i = 0; i < orders.length; i++){
      widgets.add(HistoryOrderComponent(order: orders[i]));
    }
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Align(alignment: Alignment.center, child: Text(AppLocalizations.of(context)!.order_history, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),)),
        shadowColor: Colors.black87,
        elevation: 0.4,
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.9,
              child: Column(
                children: widgets.reversed.toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

