import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/profile/profilePage.dart';

AppBar appBarHome(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double titleFontSize = screenWidth * (38 / 375);
  final double marginSize = screenWidth * (10 / 375);
  final double iconWidth = screenWidth * (40 / 375);

  return AppBar(
    title: Text(
      'OmniTrics',
      style: TextStyle(
        color: Colors.white, // White for better contrast with the gradient
        fontSize: titleFontSize,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,

    // ✅ Make background transparent to show the gradient
    backgroundColor: Colors.transparent,
    elevation: 6.0,
    shadowColor: Colors.grey,

    // ✅ Apply gradient using flexibleSpace
    flexibleSpace: Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    ),

    leading: Builder(
      builder: (context) => IconButton(
        icon: Icon(Icons.menu, color: Colors.white), // White for better contrast
        onPressed: () {
          Scaffold.of(context).openDrawer(); // Open the drawer
        },
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
