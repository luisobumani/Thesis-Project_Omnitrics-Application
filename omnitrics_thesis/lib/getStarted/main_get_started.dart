import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/getStarted/disclaimer.dart';
import 'package:omnitrics_thesis/getStarted/get_started.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class MainGetStarted extends StatelessWidget {
  MainGetStarted({super.key});
  final PageController _controller = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      body: SafeArea(
        child: Column(
          children: [
            // PageView takes up the available space.
            Expanded(
              child: PageView(
                controller: _controller,
                children: const [
                  Disclaimer(),
                  GetStarted(),
                ],
              ),
            ),
            // Dot Indicator with padding
            Padding(
              padding: const EdgeInsets.all(23.0),
              child: SmoothPageIndicator(
                controller: _controller,
                count: 2,
                effect: WormEffect(
                  dotColor: const Color.fromARGB(255, 94, 91, 99),
                  activeDotColor: Colors.deepPurple,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}