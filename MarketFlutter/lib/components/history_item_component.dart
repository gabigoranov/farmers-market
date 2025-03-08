import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market/models/purchase.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/views/purchase_details_screen.dart';
import 'package:provider/provider.dart';
import 'package:market/l10n/app_localizations.dart';

class HistoryItemComponent extends StatefulWidget {
  final Purchase order;
  final BorderRadius borderRadius;
  final bool initiallyExpanded; // Option to set initial state

  const HistoryItemComponent({
    super.key,
    required this.order,
    required this.borderRadius,
    this.initiallyExpanded = false, // Default to shrunk
  });

  @override
  State<HistoryItemComponent> createState() => _HistoryItemComponentState();
}

class _HistoryItemComponentState extends State<HistoryItemComponent> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.initiallyExpanded; // Set initial state
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!; // Localization instance

    return Consumer<NotificationProvider>(
      builder: (BuildContext context, NotificationProvider notificationProvider, Widget? child) {
        Purchase order = notificationProvider.getPurchase(widget.order.id);

        return GestureDetector(
          child: Container(
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Get.theme.colorScheme.surface,
              borderRadius: widget.borderRadius,
              boxShadow: [
                BoxShadow(
                  color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header Section (Always visible)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8), // Reduced bottom padding
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Date
                      Text(
                        DateFormat("dd MMM yyyy, hh:mm a").format(order.dateOrdered!),
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
                        ),
                      ),
                      // Status Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: order.isDelivered() ? Get.theme.colorScheme.secondary.withValues(alpha: 0.2) : Get.theme.colorScheme.tertiary.withValues(alpha: 0.2) ,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          order.isDelivered() ? l10n.delivered : l10n.in_progress,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: order.isDelivered() ? Get.theme.colorScheme.secondary : Get.theme.colorScheme.tertiary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Price and Expand Icon (Always visible)
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Total Price
                      Text(
                        "${l10n.total}: ${order.price.toStringAsFixed(2)} BGN",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
                        ),
                      ),
                      // Expand/Collapse Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _isExpanded = !_isExpanded; // Toggle expand/collapse
                          });
                        },
                        child: Row(
                          children: [
                            Text(
                              _isExpanded ? l10n.hide_details : l10n.show_details,
                              style: TextStyle(
                                fontSize: 14,
                                color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.54),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              _isExpanded ? Icons.expand_less : Icons.expand_more,
                              color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.54),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Expanded Section (Animated)
                AnimatedSize(
                  duration: const Duration(milliseconds: 300), // Animation duration
                  curve: Curves.easeInOut, // Smooth animation curve
                  alignment: Alignment.topCenter, // Expand from top to bottom
                  child: _isExpanded
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(height: 1, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.12)),
                      // Address
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.delivery_address,
                              style: TextStyle(
                                fontSize: 12,
                                color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.6),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              order.address ?? l10n.no_address_provided,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Divider(height: 1, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.12)),
                      // Order Details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            // Number of Items
                            Row(
                              children: [
                                Icon(Icons.shopping_bag_outlined, size: 16, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.54)),
                                const SizedBox(width: 8),
                                Text(
                                  "${order.orders?.length ?? 0} ${l10n.items}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
                                  ),
                                ),
                              ],
                            ),
                            // Delivery Progress
                            Row(
                              children: [
                                Icon(Icons.local_shipping_outlined, size: 16, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.54)),
                                const SizedBox(width: 8),
                                Text(
                                  "${order.orders!.where((x) => x.isDelivered).length}/${order.orders!.length} ${l10n.delivered_items}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                      : const SizedBox.shrink(), // Collapsed state (empty)
                ),
              ],
            ),
          ),
          onTap: () {
            Get.to(() => PurchaseDetails(purchase: order), transition: Transition.fade);
          },
        );
      },
    );
  }
}