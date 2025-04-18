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
                    margin: EdgeInsets.only(top: 350.h),
                    child: textHue(),
                  )),
            ),
            FadeTransition(
              opacity: _fadeText,
              child: SlideTransition(
                  position: _slideText,
                  child: Container(
                    margin: EdgeInsets.only(top: 350.h),
                    child: Container(
                      margin: EdgeInsets.only(right: 25.w),
                      alignment: Alignment.bottomRight,
                      child: TextButton(
                          style: ButtonStyle(
                            foregroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.green;
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
                                color: Colors.white,
                                fontSize: 30.sp),
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
}
