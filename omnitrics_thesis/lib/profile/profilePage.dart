import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/profile/Widget/edit_button.dart';
import 'package:omnitrics_thesis/profile/Widget/logoutBtn.dart';
import 'package:omnitrics_thesis/profile/Widget/prof_details_main.dart';
import 'package:omnitrics_thesis/profile/Widget/prof_info.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarProf(),
      body: SafeArea(
        child: Column(children: [
          profDetails(),
          profileInfoTiles(),
          editButton(context),
          logoutBtn(context),
        ]),
      ),
    );
  }

  AppBar appBarProf() {
    return AppBar(
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
