import 'package:flutter/material.dart';
import 'package:market/services/user_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/billing_details.dart';
import '../models/purchase.dart';
import '../services/purchase_service.dart';
import 'loading_screen.dart';
import 'bottom_navigation_view.dart';

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
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.select_or_create_billing_details),
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

                  // Populate form fields with selected billing details
                  if (value != null) {
                    final selectedDetails = _existingBillingDetails
                        .singleWhere((detail) => detail.id.toString() == value);
                    _fullNameController.text = selectedDetails.fullName;
                    _addressController.text = selectedDetails.address;
                    _cityController.text = selectedDetails.city;
                    _postalCodeController.text = selectedDetails.postalCode;
                    _phoneNumberController.text = selectedDetails.phoneNumber;
                    _emailController.text = selectedDetails.email;
                  } else {
                    // Clear form fields if no selection
                    _clearFormFields();
                  }
                });
              },
              items: _existingBillingDetails
                  .map((detail) => DropdownMenuItem<String>(
                value: detail.id.toString(),
                child: Text(detail.address),
              ))
                  .toList(),
              decoration: InputDecoration(
                labelText: AppLocalizations.of(context)!.select_billing_details,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            const Divider(),
            const SizedBox(height: 16.0),

            // Form for creating or editing billing details
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    const SizedBox(height: 16.0),
                    _buildTextField(_fullNameController, AppLocalizations.of(context)!.full_name),
                    const SizedBox(height: 16.0),
                    _buildTextField(_addressController, AppLocalizations.of(context)!.address),
                    const SizedBox(height: 16.0),
                    _buildTextField(_cityController, AppLocalizations.of(context)!.city),
                    const SizedBox(height: 16.0),
                    _buildTextField(_postalCodeController, AppLocalizations.of(context)!.postal_code),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                        _phoneNumberController, AppLocalizations.of(context)!.phone_number,
                        keyboardType: TextInputType.phone),
                    const SizedBox(height: 16.0),
                    _buildTextField(
                        _emailController, AppLocalizations.of(context)!.email,
                        keyboardType: TextInputType.emailAddress),
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
                      child: Text(AppLocalizations.of(context)!.create_billing_details),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _deleteBillingDetails(int.parse(_selectedBillingDetails!));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                      ),
                      child: Text(AppLocalizations.of(context)!.delete_billing_details),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          await _updateBillingDetails(int.parse(_selectedBillingDetails!));
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                      ),
                      child: Text(AppLocalizations.of(context)!.update_billing_details),
                    ),
                    _selectedBillingDetails != null
                        ? ElevatedButton(
                      onPressed: () async {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => const Loading()));
                        widget.purchase.address = _existingBillingDetails.singleWhere((element) => element.id.toString() == _selectedBillingDetails).address;
                        widget.purchase.billingDetailsId = int.parse(_selectedBillingDetails!);
                        await PurchaseService.instance.purchase(widget.purchase);
                        Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => const Navigation(index: 2)),(Route<dynamic> route) => false,);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                      ),
                      child: Text(AppLocalizations.of(context)!.finalize_purchase),
                    )
                        : Center(child: Text(AppLocalizations.of(context)!.select_your_billing_details)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// Helper to build text fields
  Widget _buildTextField(TextEditingController controller, String label,
      {TextInputType keyboardType = TextInputType.text}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
      keyboardType: keyboardType,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return AppLocalizations.of(context)!.please_enter(label);
        }
        return null;
      },
    );
  }

// Clear form fields
  void _clearFormFields() {
    _fullNameController.clear();
    _addressController.clear();
    _cityController.clear();
    _postalCodeController.clear();
    _phoneNumberController.clear();
    _emailController.clear();
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


    Navigator.push(context, MaterialPageRoute(builder: (context) {return const Loading();}));

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
      SnackBar(content: Text(AppLocalizations.of(context)!.billing_details_created)),
    );
  }

  Future<void> _updateBillingDetails(int id) async{
    // Simulate saving the data
    final newBillingDetails = BillingDetails(
        id: id,
        fullName: _fullNameController.text,
        address: _addressController.text,
        city: _cityController.text,
        postalCode: _postalCodeController.text,
        phoneNumber: _phoneNumberController.text,
        email: _emailController.text,
        userId: UserService().user.id
    );


    Navigator.push(context, MaterialPageRoute(builder: (context) {return const Loading();}));
    await UserService.instance.editBillingDetails(id, newBillingDetails);

    // Example: Add to existing list
    setState(() {
      Navigator.pop(context);
      _existingBillingDetails = UserService.instance.user.billingDetails!;
      _selectedBillingDetails = newBillingDetails.id.toString();
    });

    // Clear the form
    _clearFormFields();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.billing_details_updated)),
    );
  }

  Future<void> _deleteBillingDetails(int id) async{
    Navigator.push(context, MaterialPageRoute(builder: (context) {return const Loading();}));
    await UserService.instance.deleteBillingDetails(id);

    // Example: Add to existing list
    setState(() {
      Navigator.pop(context);
      _existingBillingDetails = UserService.instance.user.billingDetails!;
      _selectedBillingDetails = null;
    });
    // Clear the form
    _clearFormFields();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.billing_details_deleted)),
    );
  }
}
