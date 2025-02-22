import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

Center colorModesTiles() {
  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildColorModeTile('Deuteranopia', 'assets/icons/821826-200 4.svg', () {
          // Handle Deuteranopia tile tap
        }),
        _buildColorModeTile('Protanopia', 'assets/icons/821826-200 4.svg', () {
          // Handle Protanopia tile tap
        }),
        _buildColorModeTile('Tritanopia', 'assets/icons/821826-200 4.svg', () {
          // Handle Tritanopia tile tap
        }),
      ],
    ),
  );
}

Widget _buildColorModeTile(String title, String assetPath, VoidCallback onTap) {
  return GestureDetector(
    onTap: onTap, // Action when tapped
    child: Container(
      width: 100,
      height: 125,
      margin: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
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
                width: 50,
                height: 50,
              ),
            ),
            SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}