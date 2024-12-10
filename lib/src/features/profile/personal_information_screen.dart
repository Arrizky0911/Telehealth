import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';
import 'package:myapp/src/features/profile/widgets/address.dart';
import 'package:myapp/src/features/profile/widgets/medical_information.dart';
import 'package:myapp/src/features/profile/widgets/personal_details.dart';
import 'package:myapp/src/features/profile/widgets/physical_information_data.dart';
import 'package:myapp/src/features/profile/widgets/profile_image.dart';

class PersonalInformationScreen extends StatefulWidget {
  const PersonalInformationScreen({super.key});

  @override
  State<PersonalInformationScreen> createState() => _PersonalInformationScreenState();
}

class _PersonalInformationScreenState extends State<PersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isEditing = false;
  bool _isLoading = true;
  File? _image;
  String? _imageUrl;
  final picker = ImagePicker();
  DateTime? _lastUpdated;

  late PersonalDetailsData _personalDetails;
  late AddressData _addressData;
  late MedicalInformationData _medicalInfo;
  late PhysicalInformationData _physicalInfo;

  @override
  void initState() {
    super.initState();
    _personalDetails = PersonalDetailsData();
    _addressData = AddressData();
    _medicalInfo = MedicalInformationData();
    _physicalInfo = PhysicalInformationData();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        DocumentSnapshot userData = await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .get();

        if (userData.exists) {
          Map<String, dynamic> data = userData.data() as Map<String, dynamic>;
          setState(() {
            _personalDetails.loadFromMap(data);
            _addressData.loadFromMap(data['address'] ?? {});
            _medicalInfo.loadFromMap(data);
            _physicalInfo.loadFromMap(data);
            _imageUrl = data['profileImageUrl'];
            _lastUpdated = (data['lastUpdated'] as Timestamp?)?.toDate();
          });
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading user data: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveUserData() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user == null) throw Exception('User not logged in');

        String? imageUrl = _image != null ? await _uploadImage() : _imageUrl;

        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          ..._personalDetails.toMap(),
          'address': _addressData.toMap(),
          ..._medicalInfo.toMap(),
          ..._physicalInfo.toMap(),
          'profileImageUrl': imageUrl,
          'lastUpdated': FieldValue.serverTimestamp(),
        }, SetOptions(merge: true));

        setState(() {
          _isEditing = false;
          _imageUrl = imageUrl;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error updating profile: $e')),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<String?> _uploadImage() async {
    if (_image == null) return null;

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('User not logged in');

      Reference storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child('${user.uid}.jpg');

      UploadTask uploadTask = storageRef.putFile(_image!);
      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error uploading image: $e')),
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Personal Information'),
        actions: [
          IconButton(
            icon: Icon(_isEditing ? Icons.save : Icons.edit),
            onPressed: _isEditing ? _saveUserData : () => setState(() => _isEditing = true),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ProfileImage(
                  image: _image,
                  imageUrl: _imageUrl,
                  isEditing: _isEditing,
                  onImagePicked: (File image) {
                    setState(() {
                      _image = image;
                    });
                  },
                ),
                const SizedBox(height: 24),
                PersonalDetailsWidget(
                  data: _personalDetails,
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 24),
                AddressWidget(
                  data: _addressData,
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 24),
                PhysicalInformationWidget(
                  data: _physicalInfo,
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 24),
                MedicalInformationWidget(
                  data: _medicalInfo,
                  isEditing: _isEditing,
                ),
                const SizedBox(height: 24),
                if (_lastUpdated != null)
                  Text(
                    'Last updated: ${DateFormat.yMMMd().add_jm().format(_lastUpdated!)}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

