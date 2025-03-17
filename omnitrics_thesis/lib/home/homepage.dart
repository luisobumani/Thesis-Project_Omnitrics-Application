import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/about/drawer.dart';
import 'package:omnitrics_thesis/home/Widget/adjustcolorWidget.dart';
import 'package:omnitrics_thesis/home/Widget/appBar.dart';
import 'package:omnitrics_thesis/home/Widget/colormodesWidget.dart';
import 'package:omnitrics_thesis/home/Widget/generalcamBtn.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBarHome(context),
      drawer: drawerHome(context),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(bottom: screenHeight * 0.02),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              colorModesText(context),
              colorModesTiles(context),
              colorSettingsText(context),
              adjustColorTiles(context),
              generalCamBtn(context),
            ],
          ),
        ),
      ),
    );
  }

  // This method now accepts the BuildContext to compute sizes dynamically.
  Widget colorSettingsText(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: screenWidth * 0.08, left: screenWidth * 0.05),
      alignment: Alignment.centerLeft,
      child: Text(
        'Color Settings',
        style: TextStyle(
          // Font size is relative to screen width.
          fontSize: screenWidth * 0.05,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget colorModesText(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: screenWidth * 0.08, left: screenWidth * 0.05),
      alignment: Alignment.centerLeft,
      child: Text(
        'Color Modes',
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

}
