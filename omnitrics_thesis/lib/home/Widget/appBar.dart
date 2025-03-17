import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/profile/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Make sure you define _getProfileImagePath() somewhere accessible.
// For example:
Future<String?> _getProfileImagePath() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('profileImagePath');
}

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
    backgroundColor: Colors.transparent,
    elevation: 6.0,
    shadowColor: Colors.grey,
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
        icon: Icon(Icons.menu, color: Colors.white),
        onPressed: () {
          Scaffold.of(context).openDrawer();
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
          child: FutureBuilder<String?>(
            future: _getProfileImagePath(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.file(
                    File(snapshot.data!),
                    fit: BoxFit.cover,
                  ),
                );
              }
              // Fallback: show the default SVG asset if there's no image
              return SvgPicture.asset('assets/icons/profile.svg');
            },
          ),
        ),
      ),
    ],
  );
}
