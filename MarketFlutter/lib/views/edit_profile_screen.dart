import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/services/dio_service.dart';
import 'package:market/components/file_selector_component.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/user.dart';
import 'package:provider/provider.dart';

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
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _townController = TextEditingController();

  Future<void> editUser(User user) async {
    String url = 'https://api.freshly-groceries.com/api/users/${user.id}';
    print(jsonEncode(user));
    await dio.put(url, data: jsonEncode(user));
  }

  @override
  void initState() {
    super.initState();
    _firstNameController.text = UserService.instance.user.firstName;
    _lastNameController.text = UserService.instance.user.lastName;
    _ageController.text = UserService.instance.user.age.toString();
    _phoneController.text = UserService.instance.user.phoneNumber;
    _descriptionController.text = UserService.instance.user.description;
    _emailController.text = UserService.instance.user.email;
    _townController.text = UserService.instance.user.town;
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageFileProvider>(
      builder: (BuildContext context, ImageFileProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Align(
              alignment: Alignment.centerRight,
              child: Text('Edit Profile', style: TextStyle(color: Colors.black)),
            ),
            backgroundColor: Colors.white,
            elevation: 0.4,
            iconTheme: const IconThemeData(color: Colors.black), // Make back button black
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    const SizedBox(height: 16.0),
                    const FileSelectorComponent(),
                    const SizedBox(height: 24.0),
                    _buildTextField(_firstNameController, 'First Name', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid name!";
                      } else if (value.length > 12) {
                        return "Max length is 12";
                      }
                      return null;
                    }),
                    _buildTextField(_lastNameController, 'Last Name', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid name!";
                      } else if (value.length > 12) {
                        return "Max length is 12";
                      }
                      return null;
                    }),
                    _buildTextField(_ageController, 'Age', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid age!";
                      }
                      try {
                        int parsed = int.parse(value);
                        if (parsed < 18) {
                          return "Must be at least 18 years old!";
                        }
                      } catch (e) {
                        return "Please enter a valid age!";
                      }
                      return null;
                    }),
                    _buildTextField(_phoneController, 'Phone Number', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid phone number!";
                      }
                      return null;
                    }),
                    _buildTextField(_descriptionController, 'Description', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid description!";
                      }
                      return null;
                    }),
                    _buildTextField(_emailController, 'Email', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid email!";
                      }
                      return null;
                    }),
                    _buildTextField(_townController, 'Town', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid Town!";
                      }
                      return null;
                    }),
                    const SizedBox(height: 32.0),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState!.validate() && provider.selected != null) {
                          UserService.instance.user.firstName = _firstNameController.value.text;
                          UserService.instance.user.lastName = _lastNameController.value.text;
                          UserService.instance.user.age = int.parse(_ageController.value.text);
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
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor: Colors.white,
                        shadowColor: Colors.black,
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text("Save Changes", style: TextStyle(fontSize: 18)),
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

  Widget _buildTextField(TextEditingController controller, String labelText, FormFieldValidator<String> validator) {
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
      ),
    );
  }
}