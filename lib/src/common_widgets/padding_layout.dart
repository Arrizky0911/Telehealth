import 'package:flutter/material.dart';

class PaddingLayout extends StatelessWidget {
  final List<Widget> widgets;
  final Color backgroundColor;

  const PaddingLayout({
    super.key,
    required this.widgets,
    required this.backgroundColor
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: backgroundColor,
        body: SafeArea(
            child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Back Button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.pop(context),
                padding: const EdgeInsets.all(0),
                alignment: Alignment.bottomLeft,
              ),

              const SizedBox(height: 20),

              // Centered Image
              Expanded(
                child: Center(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: widgets)),
              ),
            ],
          ),
        )));
  }
}
