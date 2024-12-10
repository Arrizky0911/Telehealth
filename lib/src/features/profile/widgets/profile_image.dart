import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ProfileImage extends StatelessWidget {
  final File? image;
  final String? imageUrl;
  final bool isEditing;
  final Function(File) onImagePicked;

  const ProfileImage({
    Key? key,
    this.image,
    this.imageUrl,
    required this.isEditing,
    required this.onImagePicked,
  }) : super(key: key);

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      onImagePicked(File(pickedFile.path));
    }
  }

  void _showImageSourceActionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.camera),
                title: const Text('Take a picture'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.camera);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.pop(context);
                  _getImage(ImageSource.gallery);
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: isEditing ? () => _showImageSourceActionSheet(context) : null,
        child: Stack(
          children: [
            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.grey[200],
              backgroundImage: image != null
                  ? FileImage(image!)
                  : (imageUrl != null ? NetworkImage(imageUrl!) : null) as ImageProvider?,
              child: (image == null && imageUrl == null)
                  ? const Icon(Icons.person, size: 60, color: Colors.grey)
                  : null,
            ),
            if (isEditing)
              Positioned(
                bottom: 0,
                right: 0,
                child: CircleAvatar(
                  backgroundColor: Theme.of(context).primaryColor,
                  radius: 18,
                  child: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

