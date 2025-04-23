import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/getStarted/Widget/next_button.dart';

class MainGetStartedInfo extends StatefulWidget {

  final PageController controller;
  const MainGetStartedInfo({Key? key, required this.controller}) : super(key: key);

  @override
  _MainGetStartedInfoState createState() => _MainGetStartedInfoState();
}

class _MainGetStartedInfoState extends State<MainGetStartedInfo> {
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
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color: Colors.black.withOpacity(0), // Required child for BackdropFilter.
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(40.w),
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
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
                            Icon(
                              Icons.info,
                              size: 100.sp,
                              color: const Color.fromARGB(255, 255, 255, 255),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'INFORMATION',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '''At Omnitrics, we created a mobile application that empowers individuals with color vision deficiency to experience the world in a new way. Our app simulates different types of color blindness, offers real-time color detection, and provides color correction assistance using specialized red filters. Whether for better daily living, education, or work, Omnitrics ensures that colors remain accessible and meaningful to everyone.
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

                SizedBox(height: 7.h),
                NextButton(
                  onPressed: () {
                    widget.controller.nextPage(
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.ease,
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
