import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/googleSignIn/google_auth.dart';
import 'package:omnitrics_thesis/auth/services/authentication.dart';
import 'package:omnitrics_thesis/auth/sign-in/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Padding logoutBtn(BuildContext context) {
  return Padding(
    padding: const EdgeInsets.all(10.0),
    child: ElevatedButton(
      onPressed: () async {
        await FirebaseServices().googleSignOut();
        await AuthServices()
            .signOut(); // Ensure AuthServices is correctly instantiated
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => LoginScreen(),
          ),
        );
      },
      style: ButtonStyle(
          backgroundColor: WidgetStateProperty.resolveWith<Color>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) {
                return Colors.red.shade900; // Darker shade on pressed
              }
              return Colors.red.shade600; // Default color
            },
          ),
          padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
            EdgeInsets.symmetric(horizontal: 32.w, vertical: 16.h),
          ),
          foregroundColor: WidgetStateProperty.all<Color>(Colors.white),
        ),
      child: Text(
        'Logout',
        style: TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
  );
}
