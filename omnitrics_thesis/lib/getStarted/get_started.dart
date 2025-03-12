import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/getStarted/Widget/button.dart';
import '../auth/sign-in/login.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: screenSize.width,
          height: screenSize.height,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TITLE with responsive font size
              Text(
                'OmniTrics',
                style: TextStyle(
                  fontSize: screenSize.width * 0.18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              // BUTTON
              getStartedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => LoginScreen()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}