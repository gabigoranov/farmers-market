import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market/providers/image_provider.dart';
import 'package:market/views/authentication_screen.dart';
import 'package:market/components/file_selector_component.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/user.dart';
import 'package:market/views/loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:market/l10n/app_localizations.dart';

import '../models/notification_preferences.dart';
import '../services/dio_service.dart';
import '../services/locale_service.dart';

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
  final TextEditingController _birthDateController = TextEditingController();
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
    print(jsonEncode(user));
    await dio.post(url, data: jsonEncode(user));
  }

  Future<String> _loadTextAsset(String path) async {
    try {
      return await rootBundle.loadString(path);
    } catch (e) {
      return 'Failed to load content: $e';
    }
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
                child: Text(AppLocalizations.of(context)!.close),
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
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(AppLocalizations.of(context)!.register),
            ),
            backgroundColor: Get.theme.scaffoldBackgroundColor,
            shadowColor: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
            elevation: 0.4,
          ),
          backgroundColor: Get.theme.scaffoldBackgroundColor,
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
                    const SizedBox(height: 16.0),
                    _buildTextField(_passwordController, AppLocalizations.of(context)!.password, (value) {
                      if (value == null || value.isEmpty) {
                        return AppLocalizations.of(context)!.enter_valid_password;
                      } else if (value.length < 8) {
                        return AppLocalizations.of(context)!.password_min_length;
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
                                      AppLocalizations.of(context)!.privacy_policy,
                                      'assets/legal/pp_${LocaleService.instance.language}.txt',
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.agree_privacy_policy,
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
                                      AppLocalizations.of(context)!.terms_of_service,
                                      'assets/legal/tos_${LocaleService.instance.language}.txt',
                                    );
                                  },
                                  child: Text(
                                    AppLocalizations.of(context)!.agree_terms,
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
                            _errorMessage = AppLocalizations.of(context)!.accept_terms_privacy_policy;
                          });
                          return;
                        }
                        if (_formKey.currentState!.validate()) {
                          Get.off(const Loading(), transition: Transition.fade);
                          await registerUser(User(
                            id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                            firstName: _firstNameController.value.text,
                            lastName: _lastNameController.value.text,
                            birthDate: DateTime.parse(_birthDateController.value.text),
                            description: _descriptionController.value.text,
                            password: _passwordController.value.text,
                            phoneNumber: _phoneController.value.text,
                            town: _townController.value.text,
                            email: _emailController.value.text,
                            preferences: NotificationPreferences(userId: "3fa85f64-5717-4562-b3fc-2c963f66afa6"),
                            preferencesId: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
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
                      child: Text(AppLocalizations.of(context)!.register, style: const TextStyle(fontSize: 18)),
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