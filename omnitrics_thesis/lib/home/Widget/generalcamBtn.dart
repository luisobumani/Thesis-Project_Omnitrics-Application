import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/general_camera/camera_page.dart';

class AnimatedCameraButton extends StatefulWidget {
  const AnimatedCameraButton({Key? key}) : super(key: key);

  @override
  _AnimatedCameraButtonState createState() => _AnimatedCameraButtonState();
}

class _AnimatedCameraButtonState extends State<AnimatedCameraButton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    // 1) Remove the repeat, so it doesn't pulse continuously.
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    // Scale from 1.0 to 1.2 for a "breathing" or "bounce" effect.
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 2) Trigger the animation only once on tap:
  Future<void> _onButtonPressed() async {
    // Animate forward (scale up).
    await _controller.forward(from: 0);
    // Animate reverse (scale down).
    await _controller.reverse();
    // Navigate after the animation finishes.
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CameraPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const double baseWidth = 375.0;
    final scaleFactor = screenWidth / baseWidth;

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: 1.6 * scaleFactor * _scaleAnimation.value,
          child: FloatingActionButton(
            backgroundColor: Colors.transparent,
            elevation: 0,
            onPressed: _onButtonPressed, // Run the animation once.
            child: SizedBox(
              width: 50 * scaleFactor,
              height: 50 * scaleFactor,
              child: Image.asset(
                'assets/logos/omnitrics_gencam.png',
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
