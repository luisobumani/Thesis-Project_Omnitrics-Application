import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:omnitrics_thesis/profile/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Future<String?> _getProfileImagePath() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('profileImagePath');
}

AppBar appBarHome(BuildContext context) {
  return AppBar(
    title: Text(
      'OmniTrics',
      style: TextStyle(
        color: Colors.white,
        fontSize: 35.sp,
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
          margin: EdgeInsets.all(13.h),
          width: 30.w,
          height: 30.h,
          child: FutureBuilder<String?>(
            future: _getProfileImagePath(),
            builder: (context, snapshot) {
              // While waiting, show a circular progress indicator inside a CircleAvatar.
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircleAvatar(
                  radius: 15.r,
                  backgroundColor: Colors.grey.shade300,
                  child: const CircularProgressIndicator(),
                );
              }
              // If a valid image path is available, display the image.
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  snapshot.data!.isNotEmpty) {
                return CircleAvatar(
                  radius: 15.r,
                  backgroundImage: FileImage(File(snapshot.data!)),
                );
              }
              // Otherwise, display the default SVG asset inside a CircleAvatar.
              return CircleAvatar(
                radius: 15.r,
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
