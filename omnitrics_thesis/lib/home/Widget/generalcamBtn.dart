import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/home/general_camera/camera_page.dart';

BottomAppBar generalCamBtn(BuildContext context) {
  return BottomAppBar(
    color: Colors.white,
    // Give the BottomAppBar a larger height
    child: SizedBox(
      height: 250, // Adjust this to control how tall the bar should be
      child: Center(
        child: SizedBox(
          width: 80, // Adjust to control the icon’s width
          height: 80, // Adjust to control the icon’s height
          child: IconButton(
            padding: EdgeInsets.zero, // Remove default IconButton padding
            icon: SvgPicture.asset(
              'assets/icons/agbnakolbn;aslnm 1.svg',
              fit: BoxFit.contain,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (ctx) => const CameraPage()),
              );
            },
          ),
        ),
      ),
    ),
  );
}
