import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../models/billing_details.dart';

class PurchaseBillingDetailsScreen extends StatelessWidget {
  final BillingDetails billingDetails;

  const PurchaseBillingDetailsScreen({Key? key, required this.billingDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(alignment: Alignment.centerRight, child: Text('Billing Details', style: TextStyle(color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87), fontWeight: FontWeight.w600))),
        elevation: 0.4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          elevation: 0.4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildDetailTile(Icons.person, 'Full Name', billingDetails.fullName),
                _buildDetailTile(Icons.home, 'Address', billingDetails.address),
                _buildDetailTile(Icons.location_city, 'City', billingDetails.city),
                _buildDetailTile(Icons.markunread_mailbox, 'Postal Code', billingDetails.postalCode),
                _buildDetailTile(Icons.phone, 'Phone', billingDetails.phoneNumber),
                _buildDetailTile(Icons.email, 'Email', billingDetails.email),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDetailTile(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, size: 28, color: Colors.blueAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 14, color: Colors.grey)),
                Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
