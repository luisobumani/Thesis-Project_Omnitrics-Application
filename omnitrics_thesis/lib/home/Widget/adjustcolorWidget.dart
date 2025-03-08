import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/home/image_adj/filtered_image_page.dart';

Center adjustColorTiles(BuildContext context) {
  // Retrieve the current screen width.
  final double screenWidth = MediaQuery.of(context).size.width;
  // Define a scale factor to enlarge the widget.
  final double scaleFactor = 1.5; // Increase size by 50%

  // Scaling factors based on a reference width of 375, multiplied by the scale factor.
  final double tileWidth = screenWidth * (100 / 375) * scaleFactor;
  final double tileHeight = screenWidth * (125 / 375) * scaleFactor;
  final double marginValue = screenWidth * (15 / 375) * scaleFactor;
  final double iconSize = screenWidth * (60 / 375) * scaleFactor;
  final double fontSize = screenWidth * (12 / 375) * scaleFactor;

  return Center(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const FilteredImagePage()),
          );
          },
          child: Container(
            width: tileWidth,
            height: tileHeight,
            margin: EdgeInsets.all(marginValue),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey,
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/icons/adjustcolor.svg',
                    width: iconSize,
                    height: iconSize,
                  ),
                  SizedBox(height: marginValue / 3),
                  Text(
                    'Adjust Colors',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: fontSize,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
