import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/home/general_camera/camera_page.dart';

Widget generalCamBtn(BuildContext context) {
  return Transform.scale(
    scale: 1.6, // Adjust to resize the FAB
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
        width: 28,
        height: 28,
        child: SvgPicture.asset(
          'assets/icons/Camera.svg',
          fit: BoxFit.contain,
        ),
      ),
    ),
  );
}
