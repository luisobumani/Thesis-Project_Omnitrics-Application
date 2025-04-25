// lib/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:omnitrics_thesis/about/drawer.dart';
import 'package:omnitrics_thesis/home/Widget/adjustcolorWidget.dart';
import 'package:omnitrics_thesis/home/Widget/appBar.dart';
import 'package:omnitrics_thesis/home/Widget/colormodesWidget.dart';
import 'package:omnitrics_thesis/home/Widget/generalcamBtn.dart';
import 'package:omnitrics_thesis/home/data_table/userdata_table.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Keys for AppBar items
  final GlobalKey _menuKey    = GlobalKey();
  final GlobalKey _profileKey = GlobalKey();
  // Keys for page sections
  final GlobalKey _colorModesKey    = GlobalKey();
  final GlobalKey _colorSettingsKey = GlobalKey();
  final GlobalKey _userDataKey      = GlobalKey();
  final GlobalKey _cameraBtnKey     = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ShowCaseWidget.of(context).startShowCase([
        _menuKey,
        _profileKey,
        _colorModesKey,
        _colorSettingsKey,
        _userDataKey,
        _cameraBtnKey,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Pass the AppBar keys into your custom appBarHome
      appBar: appBarHome(
        context,
        menuKey: _menuKey,
        profileKey: _profileKey,
      ),
      drawer: drawerHome(context),
      backgroundColor: Colors.transparent,
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
                // Color Modes
                Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 20.w),
                  child: Showcase(
                    key: _colorModesKey,
                    targetPadding: EdgeInsets.zero,
                    title: 'Color Modes',
                    description:
                        'Try simulations for deuteranopia, protanopia & tritanopia.',
                    child: Text(
                      'Color Modes',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                colorModesTiles(context),

                // Color Settings
                Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 20.w),
                  child: Showcase(
                    key: _colorSettingsKey,
                    targetPadding: EdgeInsets.zero,
                    title: 'Color Settings',
                    description: 'Adjust filter intensity to suit your vision.',
                    child: Text(
                      'Color Settings',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                adjustColorTiles(context),

                // Your Data
                Padding(
                  padding: EdgeInsets.only(top: 30.h, left: 20.w),
                  child: Showcase(
                    key: _userDataKey,
                    targetPadding: EdgeInsets.zero,
                    title: 'Your Data',
                    description: 'View past test results and analytics.',
                    child: Text(
                      'Your Data',
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const UserDataChart(),

                SizedBox(height: 10.h),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Showcase(
        key: _cameraBtnKey,
        targetPadding: EdgeInsets.all(16.h),  // increased padding to fully cover icon
        title: 'Live Color Detection',
        description: 'Tap here to launch the camera scanner.',
        child: const AnimatedCameraButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}
