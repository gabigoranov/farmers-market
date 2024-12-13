import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:market/views/login_form.dart';
import 'package:market/views/register_form.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.blue,
        body: SafeArea(
          child: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(25),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 64),
                    padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 6),
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(context)!.landing_title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 44,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,

                          ),
                        ),
                        Text(
                          AppLocalizations.of(context)!.landing_description,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          mainAxisAlignment: MainAxisAlignment.center,
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
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                ),
                                child: Text(AppLocalizations.of(context)!.login, style: const TextStyle(fontSize: 24),),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 14),
                              child: OutlinedButton(
                                onPressed: (){
                                  Navigator.push(context,
                                    MaterialPageRoute(builder: (context){
                                      return const RegisterForm();
                                    }),
                                  );
                                },
                                style: OutlinedButton.styleFrom(
                                  side: const BorderSide(color: Colors.blue, width: 4), // Outline color and width
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(25), // Rounded corners
                                  ),
                                ),
                                child: Text(AppLocalizations.of(context)!.register, style: const TextStyle(fontSize: 24),),
                              ),
                            ),

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SvgPicture.asset(
                      'assets/landing.svg',
                      width: MediaQuery.of(context).size.width,  // Set the desired width
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
  }
}
