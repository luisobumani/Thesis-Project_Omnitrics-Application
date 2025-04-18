import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/sign-in/sign_up.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Row exitButton() {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        'Tell me who you are',
        style: TextStyle(
          fontSize: 20.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      Builder(
        builder: (context) {
          return IconButton(
            icon: const Icon(Icons.close),
            onPressed: () {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => const SignUpScreen()),
              );
            },
            padding: EdgeInsets.zero.w,
            constraints: const BoxConstraints(),
          );
        },
      ),
    ],
  );
}
