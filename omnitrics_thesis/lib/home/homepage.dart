import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/about/drawer.dart';
import 'package:omnitrics_thesis/home/Widget/adjustcolorWidget.dart';
import 'package:omnitrics_thesis/home/Widget/appBar.dart';
import 'package:omnitrics_thesis/home/Widget/colormodesWidget.dart';
import 'package:omnitrics_thesis/home/Widget/generalcamBtn.dart';
import 'package:omnitrics_thesis/home/data_table/userdata_table.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: appBarHome(context),
      drawer: drawerHome(context),
      backgroundColor: Colors.transparent, // Make scaffold background transparent
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.deepPurple],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.only(bottom: screenHeight * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                colorModesText(context),
                colorModesTiles(context),
                colorSettingsText(context),
                adjustColorTiles(context),
                userDataText(context),
                userData(),
                // ADD THIS SIZEDBOX TO PROVIDE SCROLL SPACE AT THE BOTTOM
                SizedBox(height: screenHeight * 0.1),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: generalCamBtn(context),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget colorSettingsText(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: screenWidth * 0.08, left: screenWidth * 0.05),
      alignment: Alignment.centerLeft,
      child: Text(
        'Color Settings',
        style: TextStyle(
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

  Widget userDataText(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      margin: EdgeInsets.only(top: screenWidth * 0.08, left: screenWidth * 0.05),
      alignment: Alignment.centerLeft,
      child: Text(
        'Your Data',
        style: TextStyle(
          fontSize: screenWidth * 0.05,
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
