import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
// Suggested code may be subject to a license. Learn more: ~LicenseLog:791657362.
  final String label;
  final VoidCallback? onPressed;
  final Color color;

  const RoundButton(
      {super.key,
      required this.label,
      required this.onPressed,
      required this.color});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 18, color: Colors.white),
        ),
      ),
    );
  }
}

class RespondButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const RespondButton(
      {super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }
}
