// lib/home/home_page.dart

import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omnitrics_thesis/about/drawer.dart';
import 'package:omnitrics_thesis/home/Widget/adjustcolorWidget.dart';
import 'package:omnitrics_thesis/home/Widget/appBar.dart';
import 'package:omnitrics_thesis/home/Widget/colormodesWidget.dart';
import 'package:omnitrics_thesis/home/Widget/generalcamBtn.dart';
import 'package:omnitrics_thesis/home/data_table/userdata_table.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:io';
import 'package:flutter/services.dart';   

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey _menuKey            = GlobalKey();
  final GlobalKey _profileKey         = GlobalKey();
  final GlobalKey _modesSectionKey    = GlobalKey();
  final GlobalKey _settingsSectionKey = GlobalKey();
  final GlobalKey _dataSectionKey     = GlobalKey();
  final GlobalKey _cameraBtnKey       = GlobalKey();

  @override
  void initState() {
    super.initState();
    _maybeStartShowcase();
  }

  Future<void> _maybeStartShowcase() async {
    final prefs = await SharedPreferences.getInstance();
    if (!(prefs.getBool('home_showcase_done') ?? false)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ShowCaseWidget.of(context).startShowCase([
          _menuKey,
          _profileKey,
          _modesSectionKey,
          _settingsSectionKey,
          _dataSectionKey,
          _cameraBtnKey,
        ]);
      });
      await prefs.setBool('home_showcase_done', true);
    }
  }

  Future<bool> _onPop() async {
  final shouldExit = await showDialog<bool>(
    context: context,
    barrierDismissible: false, // disallow tapping outside
    builder: (_) => WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: AlertDialog(
        title: const Text('Exit OmniTrics?'),
        content: const Text('Are you sure you want to exit the app?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(_, false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(_, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    ),
  ) ?? false;

  if (shouldExit) {
    if (Platform.isAndroid) {
      SystemNavigator.pop();
    } else {
      exit(0);
    }
  }
  return false; // never pop the underlying route
}


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
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
                // 1) Color Modes section
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Showcase(
                    key: _modesSectionKey,
                    targetPadding: EdgeInsets.zero,
                    title: 'Color Modes',
                    description:
                        'These tiles simulate Deuteranopia, Protanopia, and Tritanopia.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Color Modes',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        colorModesTiles(context),
                      ],
                    ),
                  ),
                ),

                // 2) Image Filter Tool section
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Showcase(
                    key: _settingsSectionKey,
                    targetPadding: EdgeInsets.only(top: 8.h, bottom: 4.h, left: 0, right: 0),
                    title: 'Color Settings',
                    description: 'Tap here to fine-tune your color filters.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Image Filter Tool',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: adjustColorTiles(context),
                        ),
                      ],
                    ),
                  ),
                ),

                // 3) Your Data section
                Padding(
                  padding: EdgeInsets.only(top: 30.h),
                  child: Showcase(
                    key: _dataSectionKey,
                    targetPadding: EdgeInsets.zero,
                    title: 'Your Data',
                    description: 'View your past test results and analytics.',
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Text(
                            'Your Data',
                            style: TextStyle(
                              fontSize: 20.sp,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.0),
                          child: UserDataChart(),
                        ),
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20.h),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: Showcase(
        key: _cameraBtnKey,
        targetPadding: EdgeInsets.all(16.h),
        title: 'Live Color Detection',
        description: 'Tap here to launch the camera scanner.',
        child: const AnimatedCameraButton(),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    ), 
    onWillPop: _onPop);
  }
}
