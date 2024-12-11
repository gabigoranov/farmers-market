import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:market/providers/image_provider.dart';

class ImageCapture extends StatefulWidget {
  const ImageCapture({super.key});

  @override
  State<ImageCapture> createState() => _ImageCaptureState();
}

class _ImageCaptureState extends State<ImageCapture> {
  File? _imageFile;

  Future<void> _pickImage() async{
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
    return Column(
      children: [
        TextButton(
          child: const Text("Upload"),
          onPressed: () async {
            await _pickImage();
          },
        ),
        _imageFile != null ? Image.file(_imageFile!) : const Text("Pick a profile picture"),
      ],
    );
  }
}