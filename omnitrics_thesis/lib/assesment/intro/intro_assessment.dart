import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/assesment/intro/Widget/start_test_btn.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class IntroAssessment extends StatefulWidget {
  const IntroAssessment({Key? key}) : super(key: key);

  @override
  State<IntroAssessment> createState() => _IntroAssessmentState();
}

class _IntroAssessmentState extends State<IntroAssessment>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeTakeTheTest;
  late Animation<Offset> _slideTakeTheTest;

  late Animation<double> _fadeDescription;
  late Animation<Offset> _slideDescription;

  late Animation<double> _fadeDisclaimer;
  late Animation<Offset> _slideDisclaimer;

  @override
  void initState() {
    super.initState();

    // Total duration: 3 seconds (1 sec each)
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    );

    // Animation for "Take the test!" (0 to 1 sec)
    _fadeTakeTheTest = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeIn),
      ),
    );
    _slideTakeTheTest = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.33, curve: Curves.easeIn),
      ),
    );

    // Animation for description (1 to 2 sec)
    _fadeDescription = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeIn),
      ),
    );
    _slideDescription = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.33, 0.66, curve: Curves.easeIn),
      ),
    );

    // Animation for disclaimer (2 to 3 sec)
    _fadeDisclaimer = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0, curve: Curves.easeIn),
      ),
    );
    _slideDisclaimer = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.66, 1.0, curve: Curves.easeIn),
      ),
    );

    // Start the staggered animation sequence
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 100.h),
                FadeTransition(
                  opacity: _fadeTakeTheTest,
                  child: SlideTransition(
                    position: _slideTakeTheTest,
                    child: takeTheTest(),
                  ),
                ),
                SizedBox(height: 60.h),
                FadeTransition(
                  opacity: _fadeDescription,
                  child: SlideTransition(
                    position: _slideDescription,
                    child: descriptionText(),
                  ),
                ),
                SizedBox(height: 60.h),
                FadeTransition(
                  opacity: _fadeDisclaimer,
                  child: SlideTransition(
                    position: _slideDisclaimer,
                    child: disclaimerText(),
                  ),
                ),
                SizedBox(height: 100.h),
                FadeTransition(
                  opacity: _fadeDisclaimer,
                  child: SlideTransition(
                    position: _slideDisclaimer,
                    child: startTestBtn(context),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container disclaimerText() {
    return Container(
      margin: EdgeInsets.only(left: 25.w, right: 30.w),
      child: Text(
        'Disclaimer: This test is based on research conducted by students. '
        'It is not guaranteed to be 100% accurate and should not be used as a substitute '
        'for professional advice. If you have any concerns or require a formal diagnosis, '
        'please consult a qualified healthcare professional for more accurate results.',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.bold,
          height: 1.4.h,
        ),
      ),
    );
  }

  Container descriptionText() {
    return Container(
      margin: EdgeInsets.only(left: 25.0.w, right: 30.0.w),
      child: Text(
        'Please take the tests before continuing. It will help us understand the type '
        'of colorblindness you have. Don’t worry, it won’t take long! Once you’re done, '
        'you can explore everything we have to offer.',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontSize: 18.sp,
          color: Colors.white,
          height: 1.4.h,
        ),
      ),
    );
  }

  Container takeTheTest() {
    return Container(
      margin: EdgeInsets.only(left: 25.0.w),
      child: Text(
        'Take the test!',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 50.sp,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }
}
