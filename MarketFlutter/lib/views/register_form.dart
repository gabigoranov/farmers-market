import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/providers/image_provider.dart';
import 'package:market/services/authentication_wrapper.dart';
import 'package:market/components/file_selector.dart';
import 'package:market/services/user_service.dart';
import 'package:market/models/user.dart';
import 'package:market/views/loading.dart';
import 'package:provider/provider.dart';

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

  Future<void> registerUser(User user) async{
    print(jsonEncode(user));
    const url = 'https://farmers-api.runasp.net/api/auth/register';
    await dio.post(url, data: jsonEncode(user));

  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ImageFileProvider>(
      builder: (BuildContext context, ImageFileProvider provider, Widget? child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Register Form'),
          ),
          backgroundColor: Colors.white,
          body: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const ImageCapture(),
                    TextFormField(
                      controller: _firstNameController,
                      decoration: const InputDecoration(
                        labelText: 'First Name',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Enter a valid name!";
                        }
                        else if(value.length > 12){
                          return "Max length is 12";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _lastNameController,
                      decoration: const InputDecoration(
                        labelText: 'Last Name',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Enter a valid name!";
                        }
                        else if(value.length > 12){
                          return "Max length is 12";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _ageController,
                      decoration: const InputDecoration(
                        labelText: 'Age',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Enter a valid age!";
                        }
                        try{
                          int parsed = int.parse(value);
                          if(parsed < 18){
                            return "Must be at least 18 years old!";
                          }
                        }
                        catch(e){
                          return "Please enter a valid age!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _phoneController,
                      decoration: const InputDecoration(
                        labelText: 'Phone Number',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Enter a valid phone number!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: const InputDecoration(
                        labelText: 'Description',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Enter a valid description!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Enter a valid email!";
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      controller: _townController,
                      decoration: const InputDecoration(
                        labelText: 'Town',
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Enter a valid Town!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16.0),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                      ),
                      validator: (value) {
                        if(value == null || value.isEmpty){
                          return "Enter a valid password!";
                        }
                        else if(value.length < 8){
                          return "Password must be at least 8 characters!";
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 32.0),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate() && provider.selected != null) {
                                    Get.off(const Loading(), transition: Transition.fade);
                                    await registerUser(User(
                                      id: "3fa85f64-5717-4562-b3fc-2c963f66afa6",
                                      firstName: _firstNameController.value.text,
                                      lastName: _lastNameController.value.text,
                                      age:  int.parse(_ageController.value.text),
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
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  shadowColor: Colors.black,
                                  elevation: 4.0,
                                ),
                                child: Text("Register", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),),
                              ),
                            ],
                          ),
                        ),
                      ],
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
}