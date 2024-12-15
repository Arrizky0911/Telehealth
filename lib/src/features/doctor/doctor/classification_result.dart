import 'package:flutter/material.dart';
import 'package:tflite/tflite.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:myapp/src/utils/image_util.dart';

class ClassificationResultScreen extends StatefulWidget {
  final File image;

  const ClassificationResultScreen({super.key, required this.image});

  @override
  State<ClassificationResultScreen> createState() => _ClassificationResultScreenState();
}

class _ClassificationResultScreenState extends State<ClassificationResultScreen> {
  List<dynamic>? _output;
  bool _loading = true;

  final Map<String, String> classLabels = {
    'nv': 'Melanocytic nevi (nv)',
    'mel': 'Melanoma (mel)',
    'bkl': 'Benign keratosis-like lesions (bkl)',
    'bcc': 'Basal cell carcinoma (bcc)',
    'akiec': 'Actinic keratoses (akiec)',
    'vasc': 'Vascular lesions (vasc)',
    'df': 'Dermatofibroma (df)'
  };

  @override
  void initState() {
    super.initState();
    loadModel().then((value) {
      setState(() {});
      classifyImage(widget.image);
    });
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  loadModel() async {
    await Tflite.loadModel(
      model: "assets/model.tflite",
      labels: "assets/labels.txt",
    );
  }

  classifyImage(File image) async {
    List<double> imageData = transformImage(image);
    var output = await Tflite.runModelOnBinary(
      binary: Float32List.fromList(imageData).buffer.asUint8List(),
      numResults: 7,
      threshold: 0.5,
    );
    setState(() {
      _output = output;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Classification Result'),
      ),
      body: _loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Image.file(widget.image),
            SizedBox(height: 20),
            _output != null && _output!.isNotEmpty
                ? Text(
              'Prediction: ${classLabels[_output![0]['label']] ?? 'Unknown'}',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )
                : Container(),
            const SizedBox(height: 10),
            _output != null && _output!.isNotEmpty
                ? Text(
              'Confidence: ${(_output![0]['confidence'] * 100).toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 18),
            )
                : Container(),
          ],
        ),
      ),
    );
  }
}

