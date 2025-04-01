import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnitrics_thesis/auth/emailVerification/email_verification_page.dart';
import 'package:omnitrics_thesis/getStarted/main_get_started.dart';
import 'package:omnitrics_thesis/home/homepage.dart';

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Check the connection state of the FirebaseAuth stream
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in, now check email verification
            final user = FirebaseAuth.instance.currentUser!;
            if (user.emailVerified) {
              return const HomePage();
            } else {
              return const VerificationScreen();
            }
          } else {
            // User is not logged in, show your get started / login page
            return MainGetStarted();
          }
        }
        // Loading indicator while waiting
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}