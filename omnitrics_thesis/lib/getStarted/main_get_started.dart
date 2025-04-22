import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/getStarted/disclaimer.dart';
import 'package:omnitrics_thesis/getStarted/get_started.dart';
import 'package:omnitrics_thesis/getStarted/main_get_started_info.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainGetStarted extends StatelessWidget {
  MainGetStarted({super.key});
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: [
                  GetStarted(controller: _controller), 
                  MainGetStartedInfo(controller: _controller),
                  const Disclaimer(),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(23.w),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: ExpandingDotsEffect(
                  activeDotColor: Colors.deepPurple,
                  dotHeight: 20.h,
                  dotWidth: 20.w,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
