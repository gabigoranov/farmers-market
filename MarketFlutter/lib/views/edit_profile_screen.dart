import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market/services/dio_service.dart';
import 'package:market/components/file_selector_component.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/user.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import '../providers/image_provider.dart';
import 'bottom_navigation_view.dart';

final dio = DioClient().dio;

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _townController = TextEditingController();

  Future<void> editUser(User user) async {
    String url = 'https://api.freshly-groceries.com/api/users/${user.id}';
    await dio.put(url, data: jsonEncode(user));
  }

  Future<void> _selectBirthDate(BuildContext context, TextEditingController controller) async {
    DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now().subtract(const Duration(days: 365 * 18)), // Default to 18 years ago
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (pickedDate != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(pickedDate);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.text = UserService.instance.user.firstName;
    _lastNameController.text = UserService.instance.user.lastName;
    _birthDateController.text = DateFormat('yyyy-MM-dd').format(UserService.instance.user.birthDate);
    _phoneController.text = UserService.instance.user.phoneNumber;
    _descriptionController.text = UserService.instance.user.description ?? "";
    _emailController.text = UserService.instance.user.email;
    _townController.text = UserService.instance.user.town;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageFileProvider>(
      builder: (BuildContext context, ImageFileProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(AppLocalizations.of(context)!.edit_profile, style: const TextStyle(color: Colors.white)),
            ),
            backgroundColor: Colors.blue,
            elevation: 0,
            iconTheme: const IconThemeData(color: Colors.white), // Make back button white
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUnfocus,
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    const FileSelectorComponent(),
                    const SizedBox(height: 24.0),
                    _buildTextField(_firstNameController, AppLocalizations.of(context)!.first_name, (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_valid_name;
                      } else if (value.length > 12) {
                        return AppLocalizations.of(context)!.max_length_12;
                      }
                      return null;
                    }),
                    _buildTextField(_lastNameController, AppLocalizations.of(context)!.last_name, (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_valid_name;
                      } else if (value.length > 12) {
                        return AppLocalizations.of(context)!.max_length_12;
                      }
                      return null;
                    }),
                    _buildDatePickerField(_birthDateController, AppLocalizations.of(context)!.birth_date, (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_valid_birth_date;
                      }
                      try {
                        DateTime birthDate = DateTime.parse(value);
                        DateTime today = DateTime.now();
                        int age = today.year - birthDate.year;

                        if (birthDate.month > today.month || (birthDate.month == today.month && birthDate.day > today.day)) {
                          age--; // Adjust if birthday hasn't occurred yet this year
                        }

                        if (age < 18) {
                          return AppLocalizations.of(context)!.must_be_18;
                        }
                      } catch (e) {
                        return AppLocalizations.of(context)!.enter_valid_birth_date;
                      }
                      return null;
                    }),
                    _buildTextField(_phoneController, AppLocalizations.of(context)!.phone_number, (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_valid_phone;
                      }
                      return null;
                    }),
                    _buildTextField(_descriptionController, AppLocalizations.of(context)!.description, (value) {
                      return null;
                    }),
                    _buildTextField(_emailController, AppLocalizations.of(context)!.email, (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_valid_email;
                      }
                      return null;
                    }),
                    _buildTextField(_townController, AppLocalizations.of(context)!.town, (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_valid_town;
                      }
                      return null;
                    }),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          UserService.instance.user.firstName = _firstNameController.value.text;
                          UserService.instance.user.lastName = _lastNameController.value.text;
                          UserService.instance.user.birthDate = DateTime.parse(_birthDateController.value.text);
                          UserService.instance.user.description = _descriptionController.value.text;
                          UserService.instance.user.phoneNumber = _phoneController.value.text;
                          UserService.instance.user.town = _townController.value.text;
                          UserService.instance.user.email = _emailController.value.text;

                          await editUser(UserService.instance.user);
                          await provider.uploadProfileImage();

                          Get.to(const Navigation(index: 0), transition: Transition.fade);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: Text(AppLocalizations.of(context)!.save, style: const TextStyle(fontSize: 18)),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, FormFieldValidator<String> validator, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          filled: true,
          fillColor: Colors.grey.shade50,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0), // Wider form fields
        ),
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String labelText, FormFieldValidator<String> validator, {bool obscureText = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        readOnly: true,
        decoration: InputDecoration(
          labelText: labelText,
          suffixIcon: const Icon(Icons.calendar_today),
          border: const OutlineInputBorder(),
        ),
        onTap: () => _selectBirthDate(context, controller),
        validator: validator,
        obscureText: obscureText,
      ),
    );
  }
}