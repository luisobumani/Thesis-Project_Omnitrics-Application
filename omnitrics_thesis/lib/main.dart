import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:omnitrics_thesis/auth/Services/auth_redirect.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniTrics',
      debugShowCheckedModeBanner: false,
      // Animated splash screen
      home: AnimatedSplashScreen(
        splash: 'assets/gifs/draft_logo.gif',
        splashIconSize: 300.0,
        centered: true,
        nextScreen: const AuthRedirect(), // Navigate to Home after the splash
        backgroundColor: Colors.deepPurple,
        duration: 3100,
      ),
    );
  }
}