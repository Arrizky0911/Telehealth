import 'package:flutter/material.dart';

class FormLayout extends StatelessWidget {
  final List<Widget> items;
  final double maxWidth;

  const FormLayout({
    super.key,
    required this.items,
    this.maxWidth = 400, // Default max width
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: maxWidth),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: items,
              ),
            ),
          ),
        ),
      ),
    );
  }
}