import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfDetailsMain extends StatelessWidget {
  final Map<String, dynamic> data;

  const ProfDetailsMain({super.key, required this.data});

  /// Retrieves the locally saved profile image path from SharedPreferences.
  Future<String?> _getProfileImagePath() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImagePath');
  }

  @override
  Widget build(BuildContext context) {
    // Determine the display name: use firstName + lastName if available; else fallback to name.
    final String firstName = data['firstName']?.toString() ?? "";
    final String lastName = data['lastName']?.toString() ?? "";
    final String displayName = (firstName.isNotEmpty && lastName.isNotEmpty)
        ? "$firstName $lastName"
        : data['name']?.toString() ?? "No Name";

    // Static condition text.
    const String condition = "Deuteranopia";

    return Container(
      margin: EdgeInsets.only(top: 10.h, bottom: 10.h, right: 10.w, left: 10.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left side: display text details.
          Container(
            margin: EdgeInsets.only(top: 20.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                SizedBox(height: 5.h),
                Text(
                  condition,
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ],
            ),
          ),
          // Right side: display profile image as a circle.
          Container(
            margin: EdgeInsets.only(top: 30.h),
            width: 120.w,
            height: 120.h,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
            ),
            child: FutureBuilder<String?>(
              future: _getProfileImagePath(),
              builder: (context, snapshot) {
                // While waiting, show a loading indicator.
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                // If a valid image path is available, display the image.
                if (snapshot.hasData &&
                    snapshot.data != null &&
                    snapshot.data!.isNotEmpty) {
                  return ClipOval(
                    child: Image.file(
                      File(snapshot.data!),
                      fit: BoxFit.cover,
                    ),
                  );
                }
                // Otherwise, display the default SVG.
                return ClipOval(
                  child: SvgPicture.asset(
                    'assets/icons/profile.svg',
                    fit: BoxFit.cover,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
