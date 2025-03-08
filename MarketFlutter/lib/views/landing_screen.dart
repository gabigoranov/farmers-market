import 'package:flutter/material.dart';
import 'package:market/l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:market/views/login_screen.dart';
import 'package:market/views/register_screen.dart';

class Landing extends StatelessWidget {
  const Landing({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Image section that covers the full width at the bottom
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Image.asset(
                'assets/landing-banner.png',
                width: MediaQuery.of(context).size.width,  // Full width of the screen
                fit: BoxFit.cover,  // Make sure the image covers the space appropriately
              ),
            ),
            // Content section above the image
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,  // Center the content
                children: [
                  // Title and Description section
                  Column(
                    children: [
                      Text(
                        AppLocalizations.of(context)!.landing_title,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 40,
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
                  const SizedBox(height: 100), // Space between text and buttons
                  // Buttons section
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 14),
                        child: TextButton(
                          onPressed: () {
                            Get.to(const LoginForm(), transition: Transition.fade);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(AppLocalizations.of(context)!.login, style: const TextStyle(fontSize: 24)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 1, horizontal: 14),
                        child: SizedBox(
                          height: 50,
                          child: OutlinedButton(
                            onPressed: () {
                              Get.to(const RegisterForm(), transition: Transition.fade);
                            },
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.blue, width: 4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                            ),
                            child: Text(AppLocalizations.of(context)!.register, style: const TextStyle(fontSize: 24)),
                          ),
                        ),
                      ),
                    ],
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
