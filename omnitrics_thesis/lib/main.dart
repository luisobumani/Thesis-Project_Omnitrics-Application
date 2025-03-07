import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:omnitrics_thesis/auth/Services/auth_redirect.dart';


void main() async {
  // Ensure that the Flutter bindings are initialized before running Firebase
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
      home: const AuthRedirect(), 
      debugShowCheckedModeBanner: false,
    );
  }
}
