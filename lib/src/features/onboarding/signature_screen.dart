import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:myapp/src/common_widgets/button/buttons.dart';
import 'package:myapp/src/common_widgets/form_layout.dart';
import 'package:myapp/src/features/main/main_screen.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';

class SignatureScreen extends StatefulWidget {
  const SignatureScreen({super.key});

  @override
  State<SignatureScreen> createState() => _SignatureScreenState();
}

class _SignatureScreenState extends State<SignatureScreen> {
  final SignatureController _controller = SignatureController(
    penStrokeWidth: 5,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );
  bool _isSignatureEmpty = true;
  bool _isLoading = false;
  double _uploadProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        _isSignatureEmpty = _controller.isEmpty;
      });
    });
  }

  void _showConfirmationDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Registration'),
          content: const Text(
            'By submitting your signature, you agree to the terms and conditions. Do you want to proceed?',
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Confirm'),
              onPressed: () {
                Navigator.of(context).pop();
                _submitSignature();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _submitSignature() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final User? user = FirebaseAuth.instance.currentUser;
      if (user == null) throw Exception('No user logged in');

      // Optimize signature image data
      final Uint8List? signatureImage = await _controller.toPngBytes(
        height: 200,
        width: 400,

      );
      if (signatureImage == null) throw Exception('Failed to get signature image');

      // Upload signature to Firebase Storage
      final String fileName = 'signatures/${user.uid}_signature.png';
      final Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
      final UploadTask uploadTask = storageRef.putData(signatureImage);

      // Add progress listener
      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        setState(() {
          _uploadProgress = snapshot.bytesTransferred / snapshot.totalBytes;
        });
      });

      // Update Firestore in parallel with the upload
      final Future<TaskSnapshot> uploadFuture = uploadTask;
      final Future<void> firestoreUpdateFuture = FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({
        'signedAt': FieldValue.serverTimestamp(),
      });

      await Future.wait([uploadFuture, firestoreUpdateFuture]);
      final String signatureUrl = await (await uploadFuture).ref.getDownloadURL();

      // Update Firestore with the signature URL
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'signatureUrl': signatureUrl});

      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const MainScreen()),
            (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('An error occurred: ${e.toString()}')),
      );
      print('Error uploading signature: $e'); // Add logging for debugging
    } finally {
      setState(() {
        _isLoading = false;
        _uploadProgress = 0.0;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return FormLayout(
      items: [
        const Center(
          child: Text(
            'Digital Signature',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          )
        ),
        const SizedBox(height: 16),
        const Text(
          'Please sign below to complete your registration and agree to the terms and conditions.',
          style: TextStyle(fontSize: 16),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 24),
        Container(
          constraints: const BoxConstraints(maxWidth: 400),
          decoration: BoxDecoration(
            border: Border.all(color: Theme.of(context).primaryColor, width: 2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Signature(
              controller: _controller,
              backgroundColor: Colors.white,
              height: 200,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RoundButton(
                label: 'Clear',
                onPressed: () {
                  _controller.clear();
                },
                color: const Color(0xFF4B5BA6),
              ),
              const SizedBox(height: 16,),
              _isLoading
                  ? Column(
                children: [
                  CircularProgressIndicator(value: _uploadProgress),
                  const SizedBox(height: 8),
                  Text('Uploading: ${(_uploadProgress * 100).toStringAsFixed(0)}%'),
                ],
              )
                  : RoundButton(
                label: "Register",
                onPressed: _isSignatureEmpty ? null : _showConfirmationDialog,
                color: const Color(0xFF4B5BA6),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),
        const Text(
          'Your signature indicates that you have read and agree to the terms and conditions of our digital health application.',
          style: TextStyle(fontSize: 12, color: Colors.grey),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}