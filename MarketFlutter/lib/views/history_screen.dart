import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/history_item_component.dart';
import 'package:market/services/purchase_service.dart';
import 'package:market/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../models/purchase.dart';
import '../providers/notification_provider.dart';

class History extends StatefulWidget {

  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  List<Purchase> orders = List.from(PurchaseService.instance.getPurchases());

  List<HistoryItemComponent> widgets = [];

  String selectedFilter = "All";
  String selectedSort = "Newest First";

  void reloadWidgets() {
    // Apply filtering
    if (selectedFilter == "Delivered") {
      orders = orders.where((order) => order.isDelivered()).toList();
    } else if (selectedFilter == "Pending") {
      orders = orders.where((order) => !order.isDenied() && !order.isDelivered()).toList();
    } else if(selectedFilter == "All") {
      orders = PurchaseService.instance.getPurchases();
    }

    // Apply sorting
    if (selectedSort == "Newest First") {
      orders.sort((a, b) => b.dateOrdered!.compareTo(a.dateOrdered!)); // Descending order
    } else {
      orders.sort((a, b) => a.dateOrdered!.compareTo(b.dateOrdered!)); // Ascending order
    }

    // Generate widgets
    if (orders.isEmpty) {
      widgets = [];
      return;
    }

    widgets = List.generate(orders.length, (index) {
      final borderRadius = BorderRadius.only(
        topLeft: Radius.circular(index == 0 ? 25 : 0),
        topRight: Radius.circular(index == 0 ? 25 : 0),
        bottomLeft: Radius.circular(index == orders.length - 1 ? 25 : 0),
        bottomRight: Radius.circular(index == orders.length - 1 ? 25 : 0),
      );
      return HistoryItemComponent(
        order: orders[index],
        borderRadius: borderRadius,
        initiallyExpanded: index == 0, // Expand only the first item
      );
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
            title: Align(alignment: Alignment.center, child: Text(AppLocalizations.of(context)!.order_history, style: TextStyle(fontSize: 32, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),  fontWeight: FontWeight.w800),)),
            shadowColor: Colors.black87,
            elevation: 0.4,
            backgroundColor: Colors.white,
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.4,
          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
                width: MediaQuery.of(context).size.width * 0.9,
                decoration: const BoxDecoration(
                  color: Colors.transparent,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12), // Optional for rounded corners
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10), // Blur effect
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.3), // Light transparency
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Sort Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200]?.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedSort,
                                items: ["Newest First", "Oldest First"].map((option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(option, style: const TextStyle(fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedSort = value;
                                      reloadWidgets();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),

                          // Filter Dropdown
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200]?.withValues(alpha: 0.8),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                value: selectedFilter,
                                items: ["All", "Delivered", "Pending"].map((option) {
                                  return DropdownMenuItem(
                                    value: option,
                                    child: Text(option, style: const TextStyle(fontSize: 14)),
                                  );
                                }).toList(),
                                onChanged: (value) {
                                  if (value != null) {
                                    setState(() {
                                      selectedFilter = value;
                                      reloadWidgets();
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 0),
                    child: Center(
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width * 0.9,
                        child: Column(
                          children: widgets,
                        ),
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );

  }
}

