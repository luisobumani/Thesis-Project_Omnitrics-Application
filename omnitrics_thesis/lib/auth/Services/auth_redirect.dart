import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnitrics_thesis/getStarted/splash.dart';
import 'package:omnitrics_thesis/home/homepage.dart';

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // Checking the connection state of the FirebaseAuth stream
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            // User is logged in, go to the HomePage
            return const HomePage();
          } else {
            // User is not logged in, show the SplashScreen or SignIn page
            return const SplashScreen();
          }
        }

        // If still waiting for the auth state to be available, show a loading indicator
        return const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        );
      },
    );
  }
}
