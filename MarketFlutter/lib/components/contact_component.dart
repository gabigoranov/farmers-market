import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:market/views/contacts_screen.dart';
import '../models/dto/contact.dart';

class ContactComponent extends StatelessWidget {
  final Contact user;

  const ContactComponent({super.key, required this.user});

  // Method for building profile picture
  Widget _buildProfilePicture() {
    return CircleAvatar(
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
    );
  }

  // Method for building user information (name and email)
  Widget _buildUserInfo() {
    return Column(
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ChatContactView(contact: user), transition: Transition.fade);
      },
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          border: Border(
            bottom: BorderSide(color: Get.theme.colorScheme.surfaceDim.withValues(alpha: 0.12), width: 1.0),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildProfilePicture(), // Profile picture
            const SizedBox(width: 16.0),
            _buildUserInfo(), // User information
          ],
        ),
      ),
    );
  }
}
