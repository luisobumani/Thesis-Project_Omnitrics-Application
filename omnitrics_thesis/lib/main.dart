import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
// import 'package:omnitrics_thesis/auth/sign-in/login.dart';
import 'package:omnitrics_thesis/getStarted/splash.dart';


void main() async {
  // Initialize Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  // Run App
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'OmniTrics',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(fontFamily: 'Inter'),
      home: const SplashScreen(),
    );
  }
}
