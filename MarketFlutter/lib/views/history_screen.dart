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
          backgroundColor: Get.theme.scaffoldBackgroundColor,
          appBar: AppBar(
            title: Align(alignment: Alignment.center, child: Text(AppLocalizations.of(context)!.order_history, style: TextStyle(fontSize: 32, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),  fontWeight: FontWeight.w800),)),
            shadowColor: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
            elevation: 0.4,
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0.4,

          ),
          body: Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 0),
                width: MediaQuery.of(context).size.width * 0.9,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Sort Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900] // Dark mode background
                              : Colors.grey[200]?.withValues(alpha: 0.8),
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
                      ),// Filter Dropdown
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 0),
                        decoration: BoxDecoration(
                          color: Theme.of(context).brightness == Brightness.dark
                              ? Colors.grey[900] // Dark mode background
                              : Colors.grey[200]?.withValues(alpha: 0.8), // Light mode background
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: selectedFilter,
                            dropdownColor: Theme.of(context).brightness == Brightness.dark ? Colors.grey[850] : Colors.white, // Ensure dropdown has a matching theme
                            items: ["All", "Delivered", "Pending"].map((option) {
                              return DropdownMenuItem(
                                value: option,
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : Colors.black, // Adaptive text color
                                  ),
                                ),
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

