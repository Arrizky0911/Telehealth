import 'package:flutter/material.dart';

class PaddingLayout extends StatelessWidget {
  final List<Widget> widgets;
  final Color backgroundColor;
  final bool backArrow;

  const PaddingLayout({
    super.key,
    required this.widgets,
    required this.backgroundColor, required this.backArrow
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
              SizedBox(
                  child: backArrow ? IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                    padding: const EdgeInsets.all(0),
                    alignment: Alignment.bottomLeft,
                  ) : null,
              ),

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
