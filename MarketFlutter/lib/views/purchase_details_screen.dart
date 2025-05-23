import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market/components/order_item_component.dart';
import 'package:market/l10n/app_localizations.dart';
import 'package:market/views/purchase_billing_details_screen.dart';
import '../models/purchase.dart';
import '../services/user_service.dart';

class PurchaseDetails extends StatelessWidget {
  final Purchase purchase;

  const PurchaseDetails({super.key, required this.purchase});

  @override
  Widget build(BuildContext context) {
    // Precalculate sizes
    final double screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(AppLocalizations.of(context)!.purchase_details, style: TextStyle(color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87), fontWeight: FontWeight.w600),),
        ),
        elevation: 0.4,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: _buildHeader(context),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
              itemCount: purchase.orders!.length,
              itemBuilder: (context, index) {
                return _buildOrderItem(context, index, screenWidth);
              },
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildBillingDetailsLink(context, purchase),
          )
        ],
      ),
    );
  }

  // Build header with date, ID, and price
  Widget _buildHeader(context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('EEE, d MMM').format(purchase.dateOrdered!.toLocal()),
                  style: _commonTextStyle(),
                ),
                Text(
                  "${AppLocalizations.of(context)!.purchase_id} ${purchase.id}",
                  style: _commonTextStyle(),
                ),
              ],
            ),
            Text(
              "${purchase.price.toStringAsFixed(2)} BGN",
              style: _priceTextStyle(),
            ),
          ],
        ),
        const SizedBox(height: 12),
        _buildStatusBadge(context),
      ],
    );
  }

  // Build status badge
  Widget _buildStatusBadge(context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: purchase.isDelivered() ? Get.theme.colorScheme.secondary.withValues(alpha: 0.2) : purchase.isDenied() ? Get.theme.colorScheme.error.withValues(alpha: 0.2) : Get.theme.colorScheme.tertiary.withValues(alpha: 0.2) ,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        purchase.isDelivered() ? AppLocalizations.of(context)!.delivered : purchase.isDenied() ? AppLocalizations.of(context)!.denied : AppLocalizations.of(context)!.in_progress,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: purchase.isDelivered() ? Get.theme.colorScheme.secondary : purchase.isDenied() ? Get.theme.colorScheme.error : Get.theme.colorScheme.tertiary,
        ),
      ),
    );
  }

  // Build individual order item
  Widget _buildOrderItem(BuildContext context, int index, double screenWidth) {
    // Determine border radius
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

    return OrderItemComponent(
      order: purchase.orders![index],
      borderRadius: borderRadius,
      width: screenWidth * 0.9,
    );
  }

  // Common text style
  TextStyle _commonTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.54),
      fontSize: 16,
    );
  }

  //Build link to billing details widget
  Widget _buildBillingDetailsLink(context, Purchase purchase) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        height: 110,
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,

          boxShadow: Theme.of(context).brightness == Brightness.light
              ? [ // Apply shadow in light mode
                  const BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: Offset(5, 5), // Shadow moved to the right and bottom
                  ),
                ]
              : [], // No shadow in dark mode
          border: Theme.of(context).brightness == Brightness.dark
              ? Border(
                  top: BorderSide(color: Colors.grey[700]!, width: 1), // Top border only
                )
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Icon(
              CupertinoIcons.home,
              color: Colors.greenAccent,
              size: 42,
            ),
            SizedBox(
              width: 260,
              child: Text(
                AppLocalizations.of(context)!.view_details_billing_details,
                style: const TextStyle(

                ),
                textAlign: TextAlign.right,
              ),
            ),
          ],
        ),
      ),
      onTap: () {
        Get.to(() => PurchaseBillingDetailsScreen(billingDetails: UserService.instance.user.billingDetails!.firstWhere((x) => x.id == purchase.billingDetailsId),), transition: Transition.rightToLeft);
      },
    );
  }

  // Price text style
  TextStyle _priceTextStyle() {
    return TextStyle(
      fontWeight: FontWeight.w600,
      color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
      fontSize: 18,
    );
  }
}
