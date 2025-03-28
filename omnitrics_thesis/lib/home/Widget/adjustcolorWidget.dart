import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/image_adj/filtered_image_page.dart';

Widget adjustColorTiles(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double horizontalPadding = screenWidth * (10 / 375);
  final double verticalPadding = screenWidth * (5 / 375);
  final double fontSize = screenWidth * (14 / 375);

  return Container(
    margin: const EdgeInsets.only(top: 16),
    child: Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (ctx) => const FilteredImagePage()),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: EdgeInsets.symmetric(
            horizontal: horizontalPadding * 2,
            vertical: verticalPadding,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        child: Text(
          'Adjust Colors',
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    ),
  );
}
