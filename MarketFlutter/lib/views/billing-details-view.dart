import 'package:flutter/material.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/profile.dart';

import '../models/billing_details.dart';
import '../models/purchase.dart';
import '../services/purchase-service.dart';
import 'loading.dart';
import 'navigation.dart';

class BillingDetailsView extends StatefulWidget {
  final Purchase purchase;
  const BillingDetailsView({super.key, required this.purchase});

  @override
  State<BillingDetailsView> createState() => _BillingDetailsViewState();
}

class _BillingDetailsViewState extends State<BillingDetailsView> {
  final _formKey = GlobalKey<FormState>();

  
  String? _selectedBillingDetails;
  List<BillingDetails> _existingBillingDetails = UserService.instance.user.billingDetails ?? []; // Example data

  // Form fields
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();
  final TextEditingController _phoneNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    print(_selectedBillingDetails);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select or Create Billing Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dropdown for existing billing details
            DropdownButtonFormField<String>(
              value: _selectedBillingDetails,
              onChanged: (value) {
                setState(() {
                  _selectedBillingDetails = value;
                });
              },
              items: _existingBillingDetails
                  .map((detail) => DropdownMenuItem<String>(

                value: detail.id.toString(),
                child: Text(detail.address),
              ))
                  .toList(),
              decoration: const InputDecoration(
                labelText: 'Select Billing Details',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Form for creating new billing details
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _fullNameController,
                      decoration: const InputDecoration(
                        labelText: 'Full Name',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your full name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _addressController,
                      decoration: const InputDecoration(
                        labelText: 'Address',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _cityController,
                      decoration: const InputDecoration(
                        labelText: 'City',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your city';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _postalCodeController,
                      decoration: const InputDecoration(
                        labelText: 'Postal Code',
                        border: OutlineInputBorder(),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your postal code';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _phoneNumberController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.phone,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your phone number';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(),
                      ),
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _saveBillingDetails();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                      ),
                      child: const Text('Create Billing Details'),
                    ),
                    _selectedBillingDetails != null ?
                    ElevatedButton(
                      onPressed: () async {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {return Loading();}));
                        widget.purchase.address = _existingBillingDetails.singleWhere((element) => element.id.toString() == _selectedBillingDetails).address;
                        widget.purchase.billingDetailsId = int.parse(_selectedBillingDetails!);
                        await PurchaseService.instance.purchase(widget.purchase);
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(builder: (context){
                            return const Navigation(index: 3);
                          }),
                          ModalRoute.withName('/'),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                      ),
                      child: const Text('Finalize Purchase'),
                    ) : const Center(child: Text("Select your billing details.")),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveBillingDetails() async{
    // Simulate saving the data
    final newBillingDetails = BillingDetails(
        id: 0,
        fullName: _fullNameController.text,
        address: _addressController.text,
        city: _cityController.text,
        postalCode: _postalCodeController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
        userId: UserService().user.id
    );


    Navigator.push(context, MaterialPageRoute(builder: (context) {return Loading();}));
    int id = await UserService.instance.postBillingDetails(newBillingDetails);

    // Example: Add to existing list
    setState(() {
      Navigator.pop(context);
      _existingBillingDetails = UserService.instance.user.billingDetails!;
      _selectedBillingDetails = newBillingDetails.id.toString();
    });

    // Clear the form
    _fullNameController.clear();
    _addressController.clear();
    _cityController.clear();
    _postalCodeController.clear();
    _phoneNumberController.clear();
    _emailController.clear();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Billing details created successfully!')),
    );
  }
}
