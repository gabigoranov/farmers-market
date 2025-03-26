import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:market/views/cart_screen.dart';
import 'package:market/views/edit_profile_screen.dart';
import 'package:market/views/landing_screen.dart';
import 'package:market/services/user_service.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/models/user.dart';
import 'package:market/l10n/app_localizations.dart';

import '../controllers/theme_controller.dart';
import '../services/locale_service.dart';

class Profile extends StatefulWidget {
  final User userData;

  const Profile({super.key, required this.userData});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final storage = FirebaseStorage.instance.ref();
  String networkImageURL = '';


  Future<String> getData() async {
    FirebaseService fbService = FirebaseService();
    try{
      String? imageUrl = await fbService.getImageLink("profiles/${widget.userData.email}");
      networkImageURL = imageUrl.isNotEmpty ? imageUrl : "";
    }
    catch(e) {
      networkImageURL = "";
    }
    // Ensure a valid string is returned
    return networkImageURL;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Get.theme.scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: double.infinity,
                  height: 220,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade400, Colors.blue.shade800],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
                Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 14,),
                      Text(
                        '${widget.userData.firstName} ${widget.userData.lastName}',
                        style: const TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      FutureBuilder<String>(
                        future: getData(),
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blue.shade700, spreadRadius: 8)],
                              ),
                              child: CircleAvatar(
                                radius: 85,
                                backgroundColor: Colors.black87,
                                backgroundImage: networkImageURL.isNotEmpty
                                    ? NetworkImage(networkImageURL) as ImageProvider
                                    : null,
                                child: networkImageURL.isNotEmpty
                                    ? null
                                    : Icon(Icons.person, size: 80, color: Colors.grey[500]),
                              ),
                            );
                          }else{
                            return const CircleAvatar(
                              backgroundColor: Colors.black87,
                              radius: 85,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 12,),
                      Text(widget.userData.town, style: const TextStyle(color: Colors.black, fontSize: 24),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
                        child: Text(widget.userData.description ?? '', style: const TextStyle(color: Colors.grey, fontSize: 20,), textAlign: TextAlign.center,),
                      )
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 22,),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),),
                    onPressed: () {
                      FirebaseService.instance.setupToken();
                      Get.to(const CartView(), transition: Transition.fade);
                    },
                    style: const ButtonStyle(
                      iconSize: WidgetStatePropertyAll(32),
                    ),
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(const EditProfile(), transition: Transition.fade);
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Get.theme.colorScheme.surface,
                          shadowColor: Colors.white,
                          foregroundColor: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),
                          side: const BorderSide(color: Colors.blue, width: 2)
                      ),
                      child: Text(AppLocalizations.of(context)!.edit_profile),

                    ),
                  ),
                  const SizedBox(width: 12,),
                  IconButton(
                    icon: Icon(Icons.settings, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87),),
                    onPressed: () {
                      showMenu(
                        context: context,
                        color: Get.theme.colorScheme.surface,
                        position: const RelativeRect.fromLTRB(100, 470, 0, 50),
                        items: [
                          PopupMenuItem<String>( value: "logout", child: Text(AppLocalizations.of(context)!.logout), ),
                          PopupMenuItem<String>( value: "lang", child: Text(AppLocalizations.of(context)!.change_lang), ),
                          PopupMenuItem<String>( value: "theme", child: Text(AppLocalizations.of(context)!.theme), ),
                        ],
                      ).then((value) async {
                        if(value == "logout"){
                          UserService.instance.logout();
                          Get.offAll(const Landing(), transition: Transition.fade);
                        }
                        else if(value == "lang"){
                          await LocaleService.instance.toggle();
                        }
                        else if(value == "theme"){
                          ThemeController.to.toggleTheme();
                        }
                      });
                    },
                    style: const ButtonStyle(
                      iconSize: WidgetStatePropertyAll(32),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22,),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: Theme.of(context).brightness == Brightness.light
                    ? [ // Apply shadow in light mode
                  const BoxShadow(
                    color: Colors.black12,
                    spreadRadius: 0,
                    blurRadius: 15,
                    offset: Offset(5, 5),
                  ),
                ]
                    : [], // No shadow in dark mode
                border: Theme.of(context).brightness == Brightness.dark
                    ? Border.all(color: Colors.grey[700]!, width: 1) // Add outline in dark mode
                    : null,
                color: Get.theme.scaffoldBackgroundColor.withValues(alpha: 0.9),
              ),
              child: Column(
                children: [
                  _buildInfoTile(Icons.person, '${widget.userData.firstName} ${widget.userData.lastName}'),
                  _buildInfoTile(Icons.calendar_month, '${AppLocalizations.of(context)!.birth_date}: ${DateFormat('yyyy-MM-dd').format(widget.userData.birthDate)}'),
                  _buildInfoTile(Icons.phone, widget.userData.phoneNumber),
                  _buildInfoTile(Icons.email, widget.userData.email),
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(IconData icon, String text) {
    return ListTile(
      leading: Icon(icon, size: 30, color: Colors.blue.shade700),
      title: Text(text, style: const TextStyle(fontSize: 18)),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
    );
  }
}
