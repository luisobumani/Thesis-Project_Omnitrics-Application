import 'package:flutter/material.dart';

class FillUpSection extends StatelessWidget {
  const FillUpSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        shadowedTextField(
          label: 'Name',
        ),
        shadowedTextField(
          label: 'Gender',
        ),
        shadowedTextField(
          label: 'Email',
        ),
        shadowedTextField(
          label: 'Current Password',
        ),
        shadowedTextField(
          label: 'New Password',
        ),
      ],
    );
  }

  Widget shadowedTextField({required String label}) {
    return Container(
      margin:
          const EdgeInsets.all(12),
      child: Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5), 
              spreadRadius: 1,
              blurRadius: 5, 
              offset: const Offset(0, 3),
            ),
          ],
          borderRadius: BorderRadius.circular(4),
        ),
        child: TextField(
          decoration: InputDecoration(
            labelText: label,
            border: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.black),
              borderRadius: BorderRadius.circular(10),
            ),
            fillColor: Colors.white,
            filled: true
          ),
        ),
      ),
    );
  }
}
