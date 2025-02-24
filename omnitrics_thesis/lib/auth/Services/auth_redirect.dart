import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/getStarted/splash.dart';
import 'package:omnitrics_thesis/home/homepage.dart';

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // If no user is logged in, go to SplashScreen
        if (!snapshot.hasData) {
          return const SplashScreen();
        }

        User? user = FirebaseAuth.instance.currentUser;

        return FutureBuilder<DocumentSnapshot>(
          future: FirebaseFirestore.instance.collection("users").doc(user!.uid).get(),
          builder: (context, userSnapshot) {
            if (userSnapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // If the user's document exists, go to HomePage;
            // otherwise, send them to the SplashScreen.
            if (userSnapshot.hasData && userSnapshot.data!.exists) {
              return const HomePage();
            } else {
              return const SplashScreen();
            }
          },
        );
      },
    );
  }
}