import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/profile/profilePage.dart';

AppBar appBarHome(BuildContext context) {
  // Get the current screen width.
  final double screenWidth = MediaQuery.of(context).size.width;

  // Define scaling factors based on a reference width of 375.
  final double titleFontSize = screenWidth * (38 / 375);
  final double marginSize = screenWidth * (10 / 375);
  final double iconWidth = screenWidth * (40 / 375);

  return AppBar(
    title: Text(
      'OmniTrics',
      style: TextStyle(
        color: Colors.black,
        fontSize: titleFontSize,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.white,
    elevation: 6.0,
    shadowColor: Colors.grey,
    leading: GestureDetector(
      onTap: () {
        // Add your functionality here
      },
      child: Container(
        margin: EdgeInsets.all(marginSize),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
        ),
        child: SvgPicture.asset(
          'assets/icons/faq.svg',
        ),
      ),
    ),
    actions: [
      GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const ProfilePage()),
          );
        },
        child: Container(
          margin: EdgeInsets.all(marginSize),
          alignment: Alignment.center,
          width: iconWidth,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: SvgPicture.asset(
            'assets/icons/Display Picture Variants.svg',
          ),
        ),
      ),
    ],
  );
}
