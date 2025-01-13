import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/views/chat_contact_view.dart';

import '../models/dto/contact.dart';

class ContactComponent extends StatelessWidget {
  final Contact user;

  const ContactComponent({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatContactView(contact: user), transition: Transition.rightToLeftWithFade);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          border: Border(
            bottom: BorderSide(color: Colors.black12, width: 1.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile picture
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey[200], // Background color
              child: ClipOval(
                child: user.profilePictureURL != null
                    ? Image.network(
                  '${user.profilePictureURL}?w=60&h=60', // Load lower-resolution image
                  fit: BoxFit.cover,
                  width: 60,
                  height: 60,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    } else {
                      return const Icon(Icons.person, size: 30); // Placeholder icon
                    }
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.person, size: 30); // Fallback icon
                  },
                )
                    : const Icon(Icons.person, size: 30), // Default icon if no URL
              ),
            ),
            const SizedBox(width: 16.0),
            // User information
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${user.firstName} ${user.lastName ?? ""}",
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4.0),
                Text(
                  user.email,
                  style: const TextStyle(
                    fontSize: 14.0,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
