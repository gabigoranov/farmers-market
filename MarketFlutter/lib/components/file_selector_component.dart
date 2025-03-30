import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/providers/image_provider.dart';

import '../l10n/app_localizations.dart';

class FileSelectorComponent extends StatefulWidget {
  const FileSelectorComponent({super.key});

  @override
  State<FileSelectorComponent> createState() => _FileSelectorComponentState();
}

class _FileSelectorComponentState extends State<FileSelectorComponent> {
  File? _imageFile;

  Future<void> _pickImage() async {
    try {
      final imagePicker = ImagePicker();
      final pickedFile = await imagePicker.pickImage(source: ImageSource.gallery);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          ImageFileProvider.instance.select(_imageFile!);
        });
      }
    } catch (e) {
      // Handle any errors that occur during image picking
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: _pickImage,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 14.0),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Colors.blue, Colors.blueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(30),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.upload_profile_picture,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          _imageFile != null
              ? ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Image.file(
              _imageFile!,
              height: 200,
              width: 200,
              fit: BoxFit.cover,
            ),
          )
              : Column(
            children: [
              const Icon(
                Icons.image_outlined,
                size: 80,
                color: Colors.grey,
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: 300,
                child: Text(
                  AppLocalizations.of(context)!.no_image_selected,
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
