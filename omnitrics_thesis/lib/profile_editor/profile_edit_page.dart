import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/profile_editor/Widget/prof_image_editor.dart';
import 'package:omnitrics_thesis/profile_editor/Widget/profile_fillup.dart';

class ProfileEditPage extends StatelessWidget {
  const ProfileEditPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarProf(),
      body: SafeArea(
        child: Column(
          children: [
            profileImageEditor(),
            FillUpSection(),
            Padding(
                padding: const EdgeInsets.all(10),
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.purple,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 16)),
                  child: Text(
                    'Save Changes',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
              )
          ],
        ),
      ),
    );
  }

  AppBar appBarProf() {
    return AppBar(
      title: const Text(
        'Edit Profile',
        style: TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
    );
  }
}
