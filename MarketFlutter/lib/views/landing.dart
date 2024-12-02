import 'package:flutter/material.dart';
import 'package:market/views/login_form.dart';
import 'package:market/views/register_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/logo.png'),
              fit: BoxFit.contain,
            ),

          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.end,

                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 14),
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return const LoginForm();
                            }),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          shadowColor: Colors.black,
                          elevation: 4.0,
                        ),
                        child: Text(AppLocalizations.of(context)!.login, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(14.0),
                      child: TextButton(
                        onPressed: (){
                          Navigator.push(context,
                            MaterialPageRoute(builder: (context){
                              return const RegisterForm();
                            }),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.blue,
                          shadowColor: Colors.black,
                          elevation: 4.0,
                        ),
                        child: Text(AppLocalizations.of(context)!.register, style: TextStyle(color: Theme.of(context).colorScheme.primary, fontSize: 24),),
                      ),
                    ),


                  ],
                ),
              ),
            ],
          ),
        ),
      );
  }
}
