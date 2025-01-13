import 'package:flutter/material.dart';
import 'package:market/components/contact_component.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:market/providers/notification_provider.dart';
import 'package:market/services/firebase_service.dart';

import 'package:market/services/user_service.dart';

import '../models/dto/contact.dart';
import 'loading.dart';


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
              backgroundColor: Colors.white,
              appBar: AppBar(
                title: Align(alignment: Alignment.centerRight, child: Text(AppLocalizations.of(context)!.chats, style: const TextStyle(fontSize: 32, fontWeight: FontWeight.w800),)),
                shadowColor: Colors.black87,
                elevation: 0.4,
                backgroundColor: Colors.white,
              ),
              body: ListView.builder(
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
