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
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _townController = TextEditingController();

  Future<void> editUser(User user) async{
    String url = 'https://farmers-api.runasp.net/api/users/${user.id}';
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
            title: const Align(alignment: Alignment.centerRight, child: Text("Edit Profile")),
            shadowColor: Colors.black87,
            elevation: 0.4,
            backgroundColor: Colors.white,
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
                    const FileSelectorComponent(),
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
                                    UserService.instance.user.firstName = _firstNameController.value.text;
                                    UserService.instance.user.lastName = _lastNameController.value.text;
                                    UserService.instance.user.age = int.parse(_ageController.value.text);
                                    UserService.instance.user.description = _descriptionController.value.text;
                                    UserService.instance.user.password = _passwordController.value.text;
                                    UserService.instance.user.phoneNumber = _phoneController.value.text;
                                    UserService.instance.user.town = _townController.value.text;
                                    UserService.instance.user.email = _emailController.value.text;

                                    await editUser(UserService.instance.user);
                                    await provider.uploadProfileImage();

                                    Get.to(const Navigation(index: 0), transition: Transition.fade);
                                  }
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                  shadowColor: Colors.black,
                                  elevation: 4.0,
                                ),
                                child: Text("Publish", style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),),
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