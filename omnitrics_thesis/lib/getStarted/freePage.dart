import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/getStarted/Widget/next_button.dart';

class Freepage extends StatefulWidget {
  const Freepage({super.key, required this.controller});
  final PageController controller;

  @override
  State<Freepage> createState() => _FreepageState();
}

class _FreepageState extends State<Freepage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() => _opacity = 1.0);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: double.infinity, // Better than 1.sw for web compatibility
          height: double.infinity, // Better than 1.sh for web compatibility
          padding: EdgeInsets.symmetric(horizontal: 20.w), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: AnimatedOpacity(
                  opacity: _opacity,
                  duration: const Duration(milliseconds: 500),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Main logo image with proper constraints
                      Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Image.asset(
                          'assets/logos/omnitrics_app_freeapp_logo.png',
                          width: 300.w, // Reduced from 450.w for better proportions
                          height: 300.h, // Fixed height for better control
                          fit: BoxFit.contain,
                        ),
                      ),

                      // Title text
                      Positioned(
                        bottom: 120.h,
                        child: SizedBox(
                          width: 300.w,
                          child: Text(
                            'Free Color Detection & Correction',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 18.sp, // Using sp for better text scaling
                              fontWeight: FontWeight.bold,
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
                          width: 320.w,
                          child: Text(
                            'Our free app instantly detects and corrects colors '
                            'for vibrant, true-to-life hues—no subscription needed.',
                            style: TextStyle(
                              color: Colors.deepPurple,
                              fontSize: 14.sp, // Using sp for better text scaling
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Next button with proper padding
              Padding(
                padding: EdgeInsets.only(bottom: 40.h),
                child: NextButton(
                  onPressed: () {
                    widget.controller.nextPage(
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