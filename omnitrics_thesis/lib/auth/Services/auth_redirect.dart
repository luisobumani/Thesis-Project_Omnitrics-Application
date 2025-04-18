import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/auth/sign-in/login.dart';
import 'package:omnitrics_thesis/home/homepage.dart';
import 'package:omnitrics_thesis/auth/emailVerification/email_verification_page.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/tell_me.dart';

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({Key? key}) : super(key: key);

  Future<bool> isProfileComplete(User user) async {
    // Check if user's profile is complete by querying Firestore.
    // Adjust the collection and field names to fit your schema.
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (!doc.exists) return false;

    // For example, check if 'firstName' exists and is not empty.
    final data = doc.data();
    return data != null &&
        data['firstName'] != null &&
        (data['firstName'] as String).isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check connection state
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            final user = FirebaseAuth.instance.currentUser!;
            // Ensure email verification first.
            if (!user.emailVerified) {
              return const VerificationScreen();
            }
            // Check if profile is complete.
            return FutureBuilder<bool>(
              future: isProfileComplete(user),
              builder: (context, profileSnapshot) {
                if (profileSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Scaffold(
                      body: Center(child: CircularProgressIndicator()));
                }
                if (profileSnapshot.hasData && profileSnapshot.data == true) {
                  // Profile is complete; user can access the homepage.
                  return const HomePage();
                } else {
                  // Profile is incomplete; route to the profile form.
                  return const ProfileForm();
                }
              },
            );
          } else {
            // Unauthenticated users can be sent to the login/signup screen.
            // Replace with your actual landing page.
            return const LoginScreen();
          }
        }
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
