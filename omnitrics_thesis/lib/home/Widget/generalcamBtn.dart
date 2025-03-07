import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/home/general_camera/camera_page.dart';

Widget generalCamBtn(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double screenHeight = MediaQuery.of(context).size.height;
  final double buttonWidth = screenWidth * (80 / 375); // Scaling based on a 375 design
  // Adjust the top margin as a fraction of the screen height (e.g., 70% from the top)
  final double topMargin = screenHeight * 0.15;

  return Container(
    margin: EdgeInsets.only(top: topMargin),
    child: Center(
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const CameraPage()),
          );
        },
        child: SvgPicture.asset(
          'assets/icons/agbnakolbn;aslnm 1.svg',
          width: buttonWidth,
        ),
      ),
    ),
  );
}
