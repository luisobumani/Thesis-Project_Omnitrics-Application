import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class FirstNameField extends StatelessWidget {
  final TextEditingController controller;

  const FirstNameField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
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
        hintText: 'Enter your first name',
      ),
    );
  }
}
