import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/services/cart_service.dart';
import 'package:market/views/bottom_navigation_view.dart';
import '../models/offer.dart';
import '../models/order.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

const storage = FlutterSecureStorage();

class PurchaseView extends StatelessWidget {
  final Order model;
  final Offer offer;

  PurchaseView({super.key, required this.model, required this.offer});

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _quantityController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: _buildForm(context),
            ),
          ),
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      title: const Align(
        alignment: Alignment.centerRight,
        child: Text('Fill in the form'),
      ),
      shadowColor: Colors.black87,
      elevation: 0.4,
      backgroundColor: Colors.white,
    );
  }

  Widget _buildForm(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildQuantityField(),
        const SizedBox(height: 20),
        _buildAddToCartButton(context),
      ],
    );
  }

  Widget _buildQuantityField() {
    return TextFormField(
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
    );
  }

  Widget _buildAddToCartButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        if (_formKey.currentState!.validate()) {
          _addToCart(context);
        }
      },
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      child: const Text('Add To Cart'),
    );
  }

  Future<void> _addToCart(BuildContext context) async {
    model.quantity = double.parse(_quantityController.value.text);
    model.price = double.parse((model.quantity * offer.pricePerKG).toStringAsFixed(2));
    model.offer = offer;
    model.title = offer.title;

    await CartService.instance.add(model);
    Get.offAll(const Navigation(index: 1), transition: Transition.fade);
  }
}
