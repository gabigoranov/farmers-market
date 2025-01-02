import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/services/user_service.dart';
import 'package:market/services/authentication_wrapper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:market/views/register_form.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  String? _errorMessage;

  Future<void> _login(String email, String password) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await UserService.instance.login(email, password);

      if (mounted) {
        Get.offAll(const AuthenticationWrapper(), transition: Transition.fade);
      }
    } on FormatException {
      setState(() {
        _errorMessage = AppLocalizations.of(context)!.cannot_login_with_seller;
      });
    } catch (_) {
      setState(() {
        _errorMessage = AppLocalizations.of(context)?.user_not_found;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(AppLocalizations.of(context)?.login ?? 'Login'),
        ),
        shadowColor: Colors.black87,
        elevation: 0.4,
        backgroundColor: Colors.white,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Center(
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.email,
                          border: const OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)?.enter_valid_email;
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16.0),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: AppLocalizations.of(context)?.password,
                          border: const OutlineInputBorder(),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return AppLocalizations.of(context)?.enter_password;
                          }
                          return null;
                        },
                      ),
                      if (_errorMessage != null) ...[
                        const SizedBox(height: 16.0),
                        Text(
                          _errorMessage!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16.0),
                      if (_isLoading)
                        const CircularProgressIndicator()
                      else
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState?.validate() ?? false) {
                                _login(
                                  _emailController.text.trim(),
                                  _passwordController.text.trim(),
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: Colors.blue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                AppLocalizations.of(context)?.login ?? 'Login',
                                style: const TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            Get.off(const RegisterForm(), transition: Transition.fade);

                          },
                          child: Text(AppLocalizations.of(context)?.create_account ?? 'Create an account'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // Bottom "Visit Website" Button
              Center(
                child: TextButton(
                  onPressed: () async {
                    final Uri url = Uri.parse('https://farmers-market.runasp.net');
                    if (!await launchUrl(url)) {
                      throw Exception('Could not launch $url');
                    }
                  },
                  child: Text(AppLocalizations.of(context)?.visit_website ?? 'Visit Website'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
