import 'package:flutter/material.dart';
import 'dart:ui'; // For ImageFilter
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Disclaimer extends StatefulWidget {
  const Disclaimer({Key? key}) : super(key: key);

  @override
  _DisclaimerState createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    // Delay for 1 second before starting the fade-in animation.
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Transparent background to allow the blur to be visible.
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // Apply the blur effect to everything behind this widget.
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0), // Required child for BackdropFilter.
            ),
          ),
          Center(
            child: Padding(
              padding: EdgeInsets.all(40.w),
              child: AnimatedOpacity(
                opacity: _opacity,
                duration: const Duration(milliseconds: 500),
                child: Container(
                  // Constrain width for larger screens/tablets so it doesn't stretch too far.
                  constraints: BoxConstraints(maxWidth: 500.w),
                  padding: EdgeInsets.all(27.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Colors.deepPurple, Color.fromARGB(255, 176, 59, 211)],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                    borderRadius: BorderRadius.circular(10.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 8.r,
                        offset: Offset(0, 4.h),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Optional icon at the top
                        Icon(
                          Icons.warning_amber_rounded,
                          size: 100.sp,
                          color: const Color.fromARGB(255, 235, 17, 17),
                        ),
                        SizedBox(height: 16.h),
                        // Disclaimer title in the middle (centered)
                        Text(
                          'DISCLAIMER',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8.h),
                        // New body text (justified)
                        Text(
                          '''This app is designed to aid individuals with color blindness by enhancing color perception. However, it's not a medical device and should not replace professional eye care. It does not cure or reverse color blindness. Results may vary based on individual vision and environmental factors. Consult an optometrist or ophthalmologist for diagnosis and treatment. Use this app as a supplementary tool to improve color differentiation, not as a definitive medical solution.
                          ''',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 15.sp,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
