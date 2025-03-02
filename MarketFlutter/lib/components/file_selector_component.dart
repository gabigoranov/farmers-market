import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/providers/image_provider.dart';

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
          // Upload Button with Styling
          ElevatedButton(
            onPressed: () async {
              await _pickImage();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue, // Button color
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30), // Rounded corners
              ),
              elevation: 5, // Shadow effect
            ),
            child: const Text(
              "Upload",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Image preview with styling
          if (_imageFile != null)
            ClipRRect(
              borderRadius: BorderRadius.circular(12), // Rounded corners for image preview
              child: Image.file(
                _imageFile!,
                height: 200,
                width: 200,
                fit: BoxFit.cover, // Crop and fill the image
              ),
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Text(
                "Pick a profile picture",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black45,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
