import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class getStartedButton extends StatelessWidget {
  final VoidCallback onPressed;
  const getStartedButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed, // Call the function when pressed
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(
          horizontal: 120.w,
          vertical: 16.h,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Text(
        'Get Started',
        style: TextStyle(
          fontSize: 16.sp,
          color: Colors.white,
        ),
      ),
    );
  }
}
