import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/getStarted/Widget/next_button.dart';

class Freepage extends StatefulWidget{
  const Freepage({super.key, required this.controller});

  final PageController controller;

  @override
  _FreepageState createState() => _FreepageState();
}

class _FreepageState extends State<Freepage> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Container(
          width: 1.sw,
          height: 1.sh,
          padding: EdgeInsets.symmetric(horizontal: 15.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/logos/omnitrics_app_freeapp_logo.png',
                    width: 450.w,
                    height: 600.h,
                    fit: BoxFit.contain,
                  ),
                  Positioned(
                    bottom: 90.h,
                    child: SizedBox(
                      width: 300.w, 
                      child: Text(
                        'Free Color Detection & Correction',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontSize: 0.05.sw,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black45,
                              offset: Offset(0, 0),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  Positioned(
                      bottom: 0.h,                
                      child: SizedBox(
                        width: 350.w,              
                        child: Text(
                          'Our free app instantly detects and corrects colors for vibrant, true-to-life hues—no subscription needed.',
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 0.04.sw,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                          softWrap: true,     
                        ),
                      ),
                    ),
                ],
              ),
              const Spacer(),
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
      ),
    );
  }
}