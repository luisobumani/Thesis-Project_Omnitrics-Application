import 'package:flutter/material.dart';

class LastNameField extends StatelessWidget {
  final TextEditingController controller;

  const LastNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        contentPadding: const EdgeInsets.symmetric(
          vertical: 10.0,
          horizontal: 12.0,
        ),
        hintText: 'Enter your last name',
      ),
    );
  }
}
