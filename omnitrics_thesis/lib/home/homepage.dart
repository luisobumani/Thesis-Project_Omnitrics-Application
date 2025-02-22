import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/Widget/adjustcolorWidget.dart';
import 'package:omnitrics_thesis/home/Widget/appBar.dart';
import 'package:omnitrics_thesis/home/Widget/colorContrast.dart';
import 'package:omnitrics_thesis/home/Widget/colormodesWidget.dart';
import 'package:omnitrics_thesis/home/Widget/configurationWidget.dart';
import 'package:omnitrics_thesis/home/Widget/generalcambtn.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: SingleChildScrollView( // Add this
          child: Column(
            children: [
              colorSettingsText(),
              adjustColorTiles(context),
              colorContrast(),
              colorModesText(),
              colorModesTiles(context),
              configurationText(),
              configurationTile(),
              generalCamBtn(context),
              SizedBox(height: 20), // Add safe space at bottom
            ],
          ),
        ),
      ),
    );
  }

  // Keep your existing helper methods unchanged below...
  Widget colorSettingsText() => Container(
    margin: EdgeInsets.only(top: 30, left: 20),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Color Settings',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget colorModesText() => Container(
    margin: EdgeInsets.only(top: 30, left: 20),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Color Modes',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );

  Widget configurationText() => Container(
    margin: EdgeInsets.only(top: 30, left: 20),
    alignment: Alignment.centerLeft,
    child: const Text(
      'Configuration',
      style: TextStyle(
        fontSize: 20,
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}