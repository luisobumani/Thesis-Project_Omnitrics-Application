import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/getStarted/Widget/next_button.dart';

class GetStarted extends StatelessWidget {
  final PageController controller;
  const GetStarted({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity, // Changed from 1.sw to work better on web
          height: double.infinity, // Changed from 1.sh to work better on web
          padding: EdgeInsets.symmetric(horizontal: 20.w), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Main logo image
                    Padding(
                      padding: EdgeInsets.all(20.w), // Responsive padding
                      child: Image.asset(
                        'assets/logos/omnitrics_logo (black_eye).png',
                        width: 250.w,
                        height: 250.h, // Fixed height for better control
                        fit: BoxFit.contain,
                      ),
                    ),
                    
                    // "All Lights are Visible" text
                    Positioned(
                      bottom: 120.h,
                      child: SizedBox(
                        width: 300.w,
                        child: Text(
                          '"All Lights are Visible"',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 16.sp, // Using sp for font scaling
                            fontWeight: FontWeight.bold,
                            fontStyle: FontStyle.italic,
                            shadows: const [
                              Shadow(
                                color: Colors.black45,
                                offset: Offset(0, 0),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                    
                    // Description text
                    Positioned(
                      bottom: 40.h,
                      child: SizedBox(
                        width: 300.w,
                        child: Text(
                          'OMNI means "all" and TRICS comes from optometrics, '
                          'reflecting our all-inclusive vision focus.',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 14.sp, // Using sp for font scaling
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Next button with some bottom padding
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: NextButton(
                  onPressed: () {
                    controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}