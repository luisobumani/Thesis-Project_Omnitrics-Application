  import 'package:flutter/material.dart';
  import 'package:dots_indicator/dots_indicator.dart';
  
  class dotIndicator extends StatelessWidget {
  const dotIndicator({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: DotsIndicator(
        dotsCount: 3,
        position: 0,
        decorator: DotsDecorator(
          color: Colors.grey,
          activeColor: Colors.deepPurple,
          size: const Size.square(8.0),
          activeSize: const Size.square(8.0),
          spacing: const EdgeInsets.all(4.0),
        ),
      ),
    );
  }
}
