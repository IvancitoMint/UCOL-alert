import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ImagePickerHelper {
  static Future<File?> pickImage(ImageSource source) async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: source);
    return image != null ? File(image.path) : null;
  }

  static void showImageOptions({
    required BuildContext context,
    required Function(File image) onImageSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text("Elegir de galería"),
                onTap: () async {
                  Navigator.pop(context);
                  File? img = await pickImage(ImageSource.gallery);
                  if (img != null) onImageSelected(img);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text("Tomar una foto"),
                onTap: () async {
                  Navigator.pop(context);
                  File? img = await pickImage(ImageSource.camera);
                  if (img != null) onImageSelected(img);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}