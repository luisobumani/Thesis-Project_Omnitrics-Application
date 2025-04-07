import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/home/filtered_camera/deuteranopia_camera_page.dart';
import 'package:omnitrics_thesis/home/filtered_camera/protanopia_camera_page.dart';
import 'package:omnitrics_thesis/home/filtered_camera/tritanopia_camera_page.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Center colorModesTiles(BuildContext context) {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildColorModeTile('Deuteranopia', 'assets/icons/821826-200 4.svg', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => DeuteranopiaCameraPage()),
          );
        }),
        _buildColorModeTile('Protanopia', 'assets/icons/821826-200 4.svg', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProtanopiaCameraPage()),
          );
        }),
        _buildColorModeTile('Tritanopia', 'assets/icons/821826-200 4.svg', () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TritanopiaCameraPage()),
          );
        }),
      ],
    ),
  );
}

Widget _buildColorModeTile(String title, String assetPath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, // Action when tapped
    child: Container(
      width: 100.w,
      height: 125.h,
      margin: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
                color: const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                spreadRadius: 1.r,
                blurRadius: 10.r,
                offset: Offset(0.w, 3.w),
              ),
        ],
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipOval(
              child: SvgPicture.asset(
                assetPath,
                width: 50.w,
                height: 50.h,
              ),
            ),
            SizedBox(height: 5.h),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
