import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/views/bottom_navigation_view.dart';
import '../models/offer.dart';
import '../models/order.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class PurchaseView extends StatefulWidget {
  final Order model;
  final Offer offer;

  PurchaseView({super.key, required this.model, required this.offer});

  @override
  State<PurchaseView> createState() => _PurchaseViewState();
}

class _PurchaseViewState extends State<PurchaseView> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Align(
          alignment: Alignment.centerRight,
          child: Text('Fill in the form'),
        ),
        elevation: 0.4,
        shadowColor: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
        backgroundColor: Get.theme.scaffoldBackgroundColor,
      ),
      resizeToAvoidBottomInset: true,  // This ensures the layout resizes when the keyboard shows
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextFormField(
                    controller: _quantityController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Quantity in Kg',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.shopping_cart),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid quantity!";
                      }
                      final quantity = double.tryParse(value);
                      if (quantity == null || quantity <= 0) {
                        return "Quantity must be more than 0";
                      }
                      return null;
                    },
                    textInputAction: TextInputAction.done, // Allow the "Done" key to submit the form
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
                      FocusScope.of(context).unfocus(); // Hide the keyboard when submitting
                      if (_formKey.currentState!.validate()) {
                        await _addToCart(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    child: const Text('Add To Cart'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addToCart(BuildContext context) async {
    widget.model.quantity = double.parse(_quantityController.value.text);
    widget.model.price = double.parse((widget.model.quantity * widget.offer.pricePerKG).toStringAsFixed(2));
    widget.model.offer = widget.offer;
    widget.model.title = widget.offer.title;
    print("OOOOOK");
    await CartService.instance.add(widget.model);
    Get.offAll(const Navigation(index: 1), transition: Transition.fade);
  }
}
