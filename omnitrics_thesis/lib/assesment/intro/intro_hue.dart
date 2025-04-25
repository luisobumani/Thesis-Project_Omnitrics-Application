import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/assesment/hue/hue_test.dart';

class IntroHue extends StatefulWidget {
  const IntroHue({Key? key}) : super(key: key);

  @override
  State<IntroHue> createState() => _IntroHueState();
}

class _IntroHueState extends State<IntroHue>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  late Animation<double> _fadeText;
  late Animation<Offset> _slideText;

  @override
  void initState() {
    super.initState();

    _controller =
        AnimationController(vsync: this, duration: const Duration(seconds: 2));

    _fadeText = Tween<double>(begin: 0.0, end: 1.0).animate(CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeIn)));

    _slideText = Tween<Offset>(begin: const Offset(0, 2.0), end: Offset.zero)
        .animate(CurvedAnimation(
            parent: _controller,
            curve: const Interval(0.0, 1.0, curve: Curves.easeIn)));

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
        colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      )),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            FadeTransition(
              opacity: _fadeText,
              child: SlideTransition(
                  position: _slideText,
                  child: Container(
                    margin: EdgeInsets.only(top: 400.h),
                    child: textHue(),
                  )),
            ),
            FadeTransition(
              opacity: _fadeText,
              child: SlideTransition(
                  position: _slideText,
                  child: Container(
                    margin: EdgeInsets.only(top: 20.h),
                    child: instructionsText(),
                  )),
            ),
            FadeTransition(
              opacity: _fadeText,
              child: SlideTransition(
                  position: _slideText,
                  child: Container(
                    margin: EdgeInsets.only(top: 300.h),
                    child: Container(
                      margin: EdgeInsets.only(right: 25.w),
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.deepPurple.shade900;
                                }
                                return Colors.white;
                              },
                            ),
                          ),
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ColorVisionApp()));
                          },
                          child: Text(
                            'Start →',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 30.sp,
                                fontStyle: FontStyle.italic),
                          )),
                    ),
                  )),
            )
          ],
        ),
      ),
    ));
  }

  Text textHue() {
    return const Text(
      'Hue Test',
      textAlign: TextAlign.center,
      style: TextStyle(
        fontSize: 50,
        fontWeight: FontWeight.bold,
        color: Colors.white,
      ),
    );
  }

  Container instructionsText() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w), // Add margin to control position
      child: Text(
        'You will be shown 12 color plates, each containing a number or shape. Choose the correct answer from the four options below each plate, then press "Next" to proceed to the next plate.',
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.normal,
          color: Colors.white,
        ),
      )
    );
  }
}
