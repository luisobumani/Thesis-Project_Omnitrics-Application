import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/getStarted/Widget/get_started_button.dart';
import '../auth/sign-in/login.dart';

class GetStarted extends StatelessWidget {
  const GetStarted({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: 1.sw, // Full screen width
          height: 1.sh, // Full screen height
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              // TITLE with responsive font size using screen width factor
              Text(
                'OmniTrics',
                style: TextStyle(
                  fontSize: 0.18.sw,
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
