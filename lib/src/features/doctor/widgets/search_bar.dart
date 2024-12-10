import 'package:flutter/material.dart';

class SearchBarCustom extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onChanged;

  const SearchBarCustom({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: TextField(
        controller: controller,
        onChanged: (_) => onChanged(),
        decoration: InputDecoration(
          hintText: 'Search doctors...',
          hintStyle: const TextStyle(fontSize: 16, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
        ),
      ),
    );
  }
}

