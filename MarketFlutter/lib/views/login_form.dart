import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:market/services/user_service.dart';
import 'package:market/views/loading.dart';
import 'package:market/views/navigation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../models/order.dart';
import '../services/authentication_wrapper.dart';
import '../services/cart-service.dart';
import '../services/firebase_service.dart';
final dio = Dio();
final storage = FlutterSecureStorage();

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm>{
  bool errorOccurred = false;
  bool isSellerError = false;


  Future<bool> login(String email, String password) async{

    try{
      await UserService.instance.login(email, password);

      Navigator.pushAndRemoveUntil(context,
        MaterialPageRoute(builder: (context){
          return const AuthenticationWrapper();
        }), (Route<dynamic> route) => false,
      );
    }
    on FormatException{
      setState(() {
        isSellerError = true;
      });
      return false;
    }
    catch(e) {
      setState(() {
        errorOccurred = true;
      });
      return false;
    }
    return true;
  }


  @override
  Widget build(BuildContext context){
    final GlobalKey<FormState> formKey = GlobalKey<FormState>();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.login),
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Colors.white,

        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.email,
                  ),
                ),
                const SizedBox(height: 16.0),
                TextFormField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context)!.password,
                  ),
                ),
                const SizedBox(height: 16.0),
                Visibility(
                  visible: errorOccurred, // Set to true when no error occurs
                  child:  const Text(
                    'User not found',
                    style: TextStyle(color: Colors.red),
                  ), // Replace with your actual widget
                ),
                Visibility(
                  visible: isSellerError, // Set to true when no error occurs
                  child:  const Text(
                    'Cannot login with a seller account',
                    style: TextStyle(color: Colors.red),
                  ), // Replace with your actual widget
                ),
                const SizedBox(height: 16.0,),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () async {
                              Navigator.push(context,
                                MaterialPageRoute(builder: (context){
                                  return Loading();
                                }),
                              );
                              bool res = await login(emailController.value.text, passwordController.value.text);
                              if(res == false)
                              {
                                Navigator.pop(context);
                              }

                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                              shadowColor: Colors.black,
                              elevation: 4.0,
                            ),
                            child: Text(AppLocalizations.of(context)!.login, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),),
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
  }
}

