// lib/home/Widget/appBar.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:showcaseview/showcaseview.dart';            // ← NEW
import 'package:omnitrics_thesis/profile/profilePage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// your existing helper
Future<String?> _getProfileImagePath() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString('profileImagePath');
}

/// Now takes optional keys for tutorial highlighting:
AppBar appBarHome(
  BuildContext context, {
  GlobalKey? menuKey,
  GlobalKey? profileKey,
}) {
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
    leading: Showcase(
      key: menuKey ?? GlobalKey(),
      title: 'Menu',
      description: 'Open the navigation drawer to access About, Settings, etc.',
      child: IconButton(
        icon: const Icon(Icons.menu, color: Colors.white),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
    ),
    actions: [
      Showcase(
        key: profileKey ?? GlobalKey(),
        title: 'Profile',
        description: 'Tap here to view or edit your profile.',
        child: GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfilePage()),
            );
          },
          child: Container(
            margin: EdgeInsets.all(13.h),
            width: 30.w,
            height: 30.h,
            child: FutureBuilder<String?>(
              future: _getProfileImagePath(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircleAvatar(
                    radius: 15.r,
                    backgroundColor: Colors.grey.shade300,
                    child: const CircularProgressIndicator(),
                  );
                }
                if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                  return CircleAvatar(
                    radius: 15.r,
                    backgroundImage: FileImage(File(snapshot.data!)),
                  );
                }
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
      ),
    ],
  );
}
