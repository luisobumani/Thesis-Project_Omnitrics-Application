import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/auth/googleSignIn/google_auth.dart';
import 'package:omnitrics_thesis/auth/services/authentication.dart';
import 'package:omnitrics_thesis/auth/sign-in/login.dart';

class ProfilePageTemp extends StatelessWidget {
  const ProfilePageTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tempPlaceholder(),
            logoutBtn(context),
          ],
        ),
      ),
    );
  }

  Padding logoutBtn(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
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
          backgroundColor: Colors.blue, // Text color
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
        ),
        child: Text(
          'Logout',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
      ),
    );
  }

  Expanded tempPlaceholder() {
    return Expanded(
      child: Center(
        child: Text(
          'Profile Page Content Here',
          style: TextStyle(fontSize: 24, color: Colors.black),
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'My Profile',
        style: TextStyle(
          color: Colors.black,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 6.0,
      shadowColor: Colors.grey,
    );
  }
}
