import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/Widget/adjustcolorWidget.dart';
import 'package:omnitrics_thesis/home/Widget/appBar.dart';
import 'package:omnitrics_thesis/home/Widget/colorContrast.dart';
import 'package:omnitrics_thesis/home/Widget/colormodesWidget.dart';
import 'package:omnitrics_thesis/home/Widget/configurationWidget.dart';
import 'package:omnitrics_thesis/home/Widget/generalcamBtn.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(context),
      body: SafeArea(
        child: SingleChildScrollView(
          // Adding bottom padding to prevent overflow
          padding: const EdgeInsets.only(bottom: 16.0),
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
            ],
          ),
        ),
      ),
    );
  }

  Container colorSettingsText() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20),
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
  }

  Container colorModesText() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20),
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
  }

  Container configurationText() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 20),
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
}
