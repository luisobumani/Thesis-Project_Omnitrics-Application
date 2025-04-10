import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/about/drawer.dart';
import 'package:omnitrics_thesis/home/Widget/adjustcolorWidget.dart';
import 'package:omnitrics_thesis/home/Widget/appBar.dart';
import 'package:omnitrics_thesis/home/Widget/colormodesWidget.dart';
// Import the file that contains your AnimatedCameraButton widget.
import 'package:omnitrics_thesis/home/Widget/generalcamBtn.dart';
import 'package:omnitrics_thesis/home/data_table/userdata_table.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarHome(context),
      drawer: drawerHome(context),
      backgroundColor: Colors.transparent, // Transparent scaffold background
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 10.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                colorModesText(context),
                colorModesTiles(context),
                colorSettingsText(context),
                adjustColorTiles(context),
                userDataText(context),
                userData(),
                // Sufficient space at the bottom for scrolling
                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
      // Use the animated button widget here
      floatingActionButton: const AnimatedCameraButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget colorSettingsText(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, left: 20.w),
      alignment: Alignment.centerLeft,
      child: Text(
        'Color Settings',
        style: TextStyle(
          fontSize: 20.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget colorModesText(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, left: 20.w),
      alignment: Alignment.centerLeft,
      child: Text(
        'Color Modes',
        style: TextStyle(
          fontSize: 20.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget userDataText(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 30.h, left: 20.w),
      alignment: Alignment.centerLeft,
      child: Text(
        'Your Data',
        style: TextStyle(
          fontSize: 20.sp,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
