import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/profile/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<String?> _getProfileImagePath() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('profileImagePath');
}

AppBar appBarHome(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  final double titleFontSize = screenWidth * (38 / 375);
  final double marginSize = screenWidth * (10 / 375);
  final double iconSize = screenWidth * (40 / 375);

  return AppBar(
    title: Text(
      'OmniTrics',
      style: TextStyle(
        color: Colors.white,
        fontSize: titleFontSize,
        fontWeight: FontWeight.bold,
      ),
    ),
    centerTitle: true,
    backgroundColor: Colors.deepPurple,
    elevation: 6.0,
    shadowColor: Colors.grey,
    leading: Builder(
      builder: (context) => IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
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
          width: iconSize,
          height: iconSize,
          child: FutureBuilder<String?>(
            future: _getProfileImagePath(),
            builder: (context, snapshot) {
              // While waiting, show a circular progress indicator inside a CircleAvatar.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  radius: iconSize / 2,
                  backgroundColor: Colors.grey.shade300,
                  child: const CircularProgressIndicator(),
                );
              }
              // If a valid image path is available, display the image.
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return CircleAvatar(
                  radius: iconSize / 2,
                  backgroundImage: FileImage(File(snapshot.data!)),
                );
              }
              // Otherwise, display the default SVG asset inside a CircleAvatar.
              return CircleAvatar(
                radius: iconSize / 2,
                backgroundColor: Colors.transparent,
                child: SvgPicture.asset(
                  'assets/icons/profile.svg',
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ),
    ],
  );
}
