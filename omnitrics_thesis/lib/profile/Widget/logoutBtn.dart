import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/googleSignIn/google_auth.dart';
import 'package:omnitrics_thesis/auth/services/authentication.dart';
import 'package:omnitrics_thesis/auth/sign-in/login.dart';

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
      style: ElevatedButton.styleFrom(
        foregroundColor: Colors.white,
        backgroundColor: const Color.fromARGB(255, 228, 36, 23), // Text color
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
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
