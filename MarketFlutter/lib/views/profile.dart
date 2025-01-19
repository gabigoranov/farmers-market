import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/views/cart_view.dart';
import 'package:market/views/edit_profile_view.dart';
import 'package:market/views/landing.dart';
import 'package:market/services/user_service.dart';
import 'package:market/services/firebase_service.dart';
import 'package:market/models/user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Profile extends StatefulWidget {
  final User userData;

  const Profile({super.key, required this.userData});

  @override
  State<Profile> createState() => _ProfileState(userData);
}

class _ProfileState extends State<Profile> {
  final storage = FirebaseStorage.instance.ref();
  String networkImageURL = '';
  late User userData;
  bool _isPasswordVisible = false;

  _ProfileState(User user) {
    userData = user;
  }


  Future<String> getData() async {
    FirebaseService fbService = FirebaseService();
    networkImageURL = await fbService.getImageLink("profiles/${userData.email}");
    return networkImageURL;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 200,
                  decoration: const BoxDecoration(
                    color: Colors.blue,
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
                        '${userData.firstName} ${userData.lastName}',
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
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [BoxShadow(blurRadius: 10, color: Colors.blue, spreadRadius: 8)],
                              ),
                              child: CircleAvatar(
                                radius: 85,
                                backgroundColor: Colors.black87,
                                backgroundImage: NetworkImage(networkImageURL),

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
                      Text(userData.town, style: const TextStyle(color: Colors.black, fontSize: 24),),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 2),
                        child: Text(userData.description, style: const TextStyle(color: Colors.grey, fontSize: 20,), textAlign: TextAlign.center,),
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
                    icon: const Icon(Icons.shopping_cart),
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
                          backgroundColor: Colors.white,
                          shadowColor: Colors.white,
                          foregroundColor: Colors.black87,
                          side: const BorderSide(color: Colors.blue, width: 2)
                      ),
                      child: Text(AppLocalizations.of(context)!.edit_profile),

                    ),
                  ),
                  const SizedBox(width: 12,),
                  IconButton(
                    icon: const Icon(Icons.settings),
                    onPressed: () {
                      showMenu(
                        context: context,
                        position: const RelativeRect.fromLTRB(100, 470, 0, 50),
                        items: [
                          PopupMenuItem<String>( value: AppLocalizations.of(context)!.logout, child: Text(AppLocalizations.of(context)!.logout), ),
                          PopupMenuItem<String>( value: AppLocalizations.of(context)!.change_lang, child: Text(AppLocalizations.of(context)!.change_lang), ),
                        ],
                      ).then((value) async {
                        if(value == AppLocalizations.of(context)!.logout){
                          UserService.instance.logout();
                          Get.offAll(const Landing(), transition: Transition.fade);
                        }
                        else if(value == AppLocalizations.of(context)!.change_lang){
                          final currentLocale = Get.locale?.languageCode;
                          if (currentLocale == 'en') {
                            await Get.updateLocale(const Locale('bg'));
                          } else {
                            await Get.updateLocale(const Locale('en'));
                          }
                          setState(() {

                          });
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
            Column(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.person, size: 30, color: Colors.black87,),
                    title: Text("${userData.firstName} ${userData.lastName}",
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.calendar_month, size: 30, color: Colors.black87),
                    title: Text("${AppLocalizations.of(context)!.age}: ${userData.age}",
                        style: const TextStyle(fontSize: 18)),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.phone, size: 30, color: Colors.black87),
                    title:
                    Text(userData.phoneNumber, style: const TextStyle(fontSize: 18)),
                  ),
                ),
                Container(
                  decoration: const BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.grey, width: 1.0),
                    ),
                  ),
                  child: ListTile(
                    leading: const Icon(Icons.email, size: 30, color: Colors.black87),
                    title: Text(userData.email, style: const TextStyle(fontSize: 18)),
                  ),
                ),
              ],
            )

          ],
        ),
      ),
    );
  }
}
