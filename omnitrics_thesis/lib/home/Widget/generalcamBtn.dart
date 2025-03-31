import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/home/general_camera/camera_page.dart';

Widget generalCamBtn(BuildContext context) {
  // Get the device's screen width.
  final screenWidth = MediaQuery.of(context).size.width;
  // Define a base width for your design.
  const double baseWidth = 375.0;
  // Calculate a scale factor relative to the base width.
  final scaleFactor = screenWidth / baseWidth;
  
  return Transform.scale(
    scale: 1.6 * scaleFactor, // Multiply the original scale by the factor.
    child: FloatingActionButton(
      backgroundColor: Colors.transparent,
      elevation: 0,           // Removes the default shadow
      focusElevation: 0,      // Removes shadow on focus
      hoverElevation: 0,      // Removes shadow on hover
      highlightElevation: 0,  // Removes shadow on tap
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (ctx) => const CameraPage()),
        );
      },
      child: SizedBox(
        width: 28 * scaleFactor,  // Scale the icon width dynamically.
        height: 28 * scaleFactor, // Scale the icon height dynamically.
        child: SvgPicture.asset(
          'assets/icons/Camera.svg',
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}

