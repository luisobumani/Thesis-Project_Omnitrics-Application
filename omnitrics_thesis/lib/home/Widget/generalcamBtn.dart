import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/general_camera/camera_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AnimatedCameraButton extends StatefulWidget {
  const AnimatedCameraButton({Key? key}) : super(key: key);

  @override
  _AnimatedCameraButtonState createState() => _AnimatedCameraButtonState();
}

class _AnimatedCameraButtonState extends State<AnimatedCameraButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

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

  Future<void> _onButtonPressed() async {
    await _controller.forward(from: 0);
    await _controller.reverse();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (ctx) => const CameraPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, -10.h), // Raises the button by 15 logical pixels
          child: Transform.scale(
            scale: _scaleAnimation.value * 1.6,
            child: FloatingActionButton(
              backgroundColor: Colors.transparent,
              elevation: 0,
              onPressed: _onButtonPressed,
              child: SizedBox(
                width: 50.w,
                height: 50.w,
                child: Image.asset(
                  'assets/logos/omnitrics_gencam.png',
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
