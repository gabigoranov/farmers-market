import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/components/contact_component.dart';
import 'package:market/l10n/app_localizations.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/firebase_service.dart';

import 'package:market/services/user_service.dart';

import '../models/dto/contact.dart';
import 'loading_screen.dart';


class ChatsView extends StatefulWidget {
  const ChatsView({super.key});

  @override
  State<ChatsView> createState() => _ChatsViewState();
}

class _ChatsViewState extends State<ChatsView> {
  late List<Contact> contacts;

  Future loadContacts() async{
    var chats = NotificationProvider.instance.messages;
    contacts = await UserService.instance.getAllContacts(chats.keys.toList());
    for(var contact in contacts){
      contact.profilePictureURL = await FirebaseService.instance.getImageLink("profiles/${contact.email}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: loadContacts(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Loading(); // Show a loading indicator
          } else if (snapshot.hasError) {
          return const Text('Error loading contacts'); // Handle errors
          } else {
            return Scaffold(
              backgroundColor: Get.theme.scaffoldBackgroundColor,
              appBar: AppBar(
                title: Align(alignment: Alignment.centerRight, child: Text(AppLocalizations.of(context)!.chats, style: TextStyle(fontSize: 32, color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.87), fontWeight: FontWeight.w800),)),
                shadowColor: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.54),
                elevation: 0.4,
                backgroundColor: Get.theme.scaffoldBackgroundColor,
              ),
              body: contacts.isEmpty ? Center(
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.chat,
                        size: 140,
                        color: Get.theme.colorScheme.surfaceDim.withAlpha(60),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        AppLocalizations.of(context)!.chats_no_contacts,
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 16,
                          color: Get.theme.colorScheme.surfaceDim.withAlpha(140),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ) : ListView.builder(
                itemCount: contacts.length,
                itemBuilder: (context, index) {
                  return ContactComponent(user: contacts[index],);
                },
              ),
            );
          }
        }
    );
  }
}
