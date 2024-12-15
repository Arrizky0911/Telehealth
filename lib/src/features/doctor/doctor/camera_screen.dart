import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:myapp/src/features/doctor/doctor/classification_result.dart';

class CameraScreen extends StatefulWidget {
  final String title;
  const CameraScreen({super.key, required this.title});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  File? _image;
  final picker = ImagePicker();
  bool isScanning = false;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  Future<void> _initializeCamera() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    final status = await Permission.camera.request();
    if (status.isGranted) {
      _controller = CameraController(cameras[0], ResolutionPreset.high);
      await _controller!.initialize();
      if (mounted) setState(() {});
    } else {
      debugPrint('Camera permission denied');
    }
  }

  Future<void> _captureImage() async {
    if (_controller == null || !_controller!.value.isInitialized) return;

    try {
      final image = await _controller!.takePicture();
      setState(() {
        _image = File(image.path);
      });
      _showConfirmationDialog();
    } catch (e) {
      debugPrint('Error capturing image: $e');
    }
  }

  Future<void> _getImage(ImageSource source) async {
    try {
      final pickedFile = await picker.pickImage(source: source);
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
        _showConfirmationDialog();
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  Future<void> _showConfirmationDialog() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Confirm Image'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (_image != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.file(
                      _image!,
                      height: 200,
                      fit: BoxFit.cover,
                    ),
                  ),
                const SizedBox(height: 16),
                const Text('Would you like to proceed with this image?'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                setState(() {
                  _image = null;
                });
              },
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(context).pop();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ClassificationResultScreen(image: _image!),
                  ),
                );
              },
              child: const Text('Proceed'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Background
            Container(color: Colors.black),

            // Camera preview in the middle
            if (_controller != null && _controller!.value.isInitialized)
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.8,
                    height: MediaQuery.of(context).size.width * 0.8,
                    child: CameraPreview(_controller!),
                  ),
                ),
              ),

            // Overlay UI
            Column(
              children: [
                // Top bar with metrics
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _buildMetricCard('128', 'mmHg', Colors.green),
                      _buildMetricCard('78', 'bpm', Colors.red),
                    ],
                  ),
                ),

                const Spacer(),

                // Bottom toolbar
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildToolbarButton(
                        Icons.photo_library,
                            () => _getImage(ImageSource.gallery),
                      ),
                      _buildToolbarButton(
                        Icons.camera_alt,
                        _captureImage,
                        large: true,
                      ),
                      _buildToolbarButton(
                        Icons.settings,
                            () {
                          // Add settings logic here
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Back button
            Positioned(
              top: 16,
              left: 16,
              child: IconButton(
                icon: const Icon(
                  Icons.arrow_back,
                  color: Colors.white,
                ),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMetricCard(String value, String unit, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              color: color,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToolbarButton(IconData icon, VoidCallback onPressed,
      {bool large = false}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon),
        onPressed: onPressed,
        padding: EdgeInsets.all(large ? 16 : 12),
        iconSize: large ? 32 : 24,
        color: Colors.black87,
      ),
    );
  }
}

