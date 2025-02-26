import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:market/providers/image_provider.dart';
import 'package:market/views/authentication_screen.dart';
import 'package:market/components/file_selector_component.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/user.dart';
import 'package:market/views/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../services/dio_service.dart';

final dio = DioClient().dio;

class RegisterForm extends StatefulWidget {
  const RegisterForm({super.key});

  @override
  State<RegisterForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<RegisterForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _townController = TextEditingController();

  String? _errorMessage;
  bool _privacyPolicyAccepted = false;
  bool _termsOfServiceAccepted = false;

  Future<void> registerUser(User user) async {
    const url = 'https://api.freshly-groceries.com/api/auth/register';
    await dio.post(url, data: jsonEncode(user));
  }

  Future<String> _loadTextAsset(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      return 'Failed to load content: $e';
    }
  }

  void _showPolicyDialog(String title, String contentPath) async {
    String content = await _loadTextAsset(contentPath);

    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(title),
            content: SingleChildScrollView(
              child: Text(content),
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(AppLocalizations.of(context)?.close ?? 'Close'),
              ),
            ],
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageFileProvider>(
      builder: (BuildContext context, ImageFileProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Align(
              alignment: Alignment.centerRight,
              child: Text('Register', style: TextStyle(color: Colors.white)),
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
                    const SizedBox(height: 16.0),
                    _buildTextField(_passwordController, 'Password', (value) {
                      if (value == null || value.isEmpty) {
                        return "Enter a valid password!";
                      } else if (value.length < 8) {
                        return "Password must be at least 8 characters!";
                      }
                      return null;
                    }, obscureText: true),
                    Column(
                        children: [
                          Row(
                            children: [
                              Checkbox(
                                value: _privacyPolicyAccepted,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _privacyPolicyAccepted = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _showPolicyDialog(
                                      AppLocalizations.of(context)?.privacy_policy ?? 'Privacy Policy',
                                      'assets/legal/privacy_policy.txt',
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)?.agree_privacy_policy ??
                                        'I agree to the Privacy Policy',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Terms of Service Checkbox
                          Row(
                            children: [
                              Checkbox(
                                value: _termsOfServiceAccepted,
                                onChanged: (bool? value) {
                                  setState(() {
                                    _termsOfServiceAccepted = value ?? false;
                                  });
                                },
                              ),
                              Expanded(
                                child: GestureDetector(
                                  onTap: () {
                                    _showPolicyDialog(
                                      AppLocalizations.of(context)?.terms_of_service ?? 'Terms of Service',
                                      'assets/legal/terms_of_service.txt',
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)?.agree_terms ??
                                        'I agree to the Terms of Service',
                                    style: const TextStyle(
                                      color: Colors.blue,
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ]
                    ),
                    if (_errorMessage != null) ...[
                      const SizedBox(height: 16.0),
                      Text(
                        _errorMessage!,
                        style: const TextStyle(color: Colors.red),
                        textAlign: TextAlign.center,
                      ),
                    ],
                    const SizedBox(height: 32.0),

                    ElevatedButton(
                      onPressed: () async {
                        if (!_privacyPolicyAccepted || !_termsOfServiceAccepted) {
                          setState(() {
                            _errorMessage = AppLocalizations.of(context)?.accept_terms_privacy_policy
                                ?? 'Please accept the Privacy Policy and Terms of Service';
                          });
                          return;
                        }
                        if (_formKey.currentState!.validate() && provider.selected != null) {
                          Get.off(const Loading(), transition: Transition.fade);
                          await registerUser(User(
                            id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                            firstName: _firstNameController.value.text,
                            lastName: _lastNameController.value.text,
                            age: int.parse(_ageController.value.text),
                            description: _descriptionController.value.text,
                            password: _passwordController.value.text,
                            phoneNumber: _phoneController.value.text,
                            town: _townController.value.text,
                            email: _emailController.value.text,
                            discriminator: 0,
                            boughtOrders: [],
                          ));
                          await UserService.instance.login(_emailController.value.text, _passwordController.value.text);
                          await provider.uploadProfileImage();

                          Get.offAll(const AuthenticationWrapper(), transition: Transition.fade);
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
                      child: const Text("Register", style: TextStyle(fontSize: 18)),
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
}