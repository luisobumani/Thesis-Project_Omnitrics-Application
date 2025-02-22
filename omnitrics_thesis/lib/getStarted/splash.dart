import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/getStarted/Widget/button.dart';
import 'package:omnitrics_thesis/getStarted/Widget/dotIndicator.dart';
import '../auth/sign-in/login.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Title
              const Text(
                'OmniTrics',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  height: 5,
                ),
              ),
              const SizedBox(height: 200),

              const Spacer(),

              // Button
              getStartedButton(
                onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),

              const SizedBox(height: 32),

              // Dot Indicator
              dotIndicator(),

              const SizedBox(height: 32), // Bottom padding
            ],
          ),
        ),
      ),
    );
  }
}


