import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BirthdateField extends StatelessWidget {
  final TextEditingController controller;

  const BirthdateField({super.key, required this.controller});

  Future<void> _selectDate(BuildContext context) async {
    // Show the date picker dialog
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    // If a date is picked, format and update the controller's text
    if (picked != null) {
      controller.text = DateFormat('MM/dd/yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      readOnly: true, // Prevent manual editing
      onTap: () => _selectDate(context),
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.r),
          borderSide: const BorderSide(color: Colors.grey),
        ),
        enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
                        borderSide: BorderSide(
                          color: Colors.grey.shade300,
                        ),
                      ),
        contentPadding: EdgeInsets.symmetric(
          vertical: 14.0.h,
          horizontal: 12.0.w,
        ),
        hintText: 'MM/DD/YYYY',
      ),
    );
  }
}
