import 'package:flutter/material.dart';

class ProfilePageTemp extends StatelessWidget {
  const ProfilePageTemp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            tempPlaceholder(),
            logoutBtn(),
          ],
        ),
      ),
    );
  }

  Padding logoutBtn() {
    return Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: () {
                // Dito mo ilagay jb
                
              },
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.blue, // Text color
                padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              ),
              child: Text(
                'Logout',
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
            ),
          );
  }

  Expanded tempPlaceholder() {
    return Expanded(
            child: Center(
              child: Text(
                'Profile Page Content Here',
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          );
  }

  AppBar appBar() {
    return AppBar(
      title: Text(
        'My Profile',
        style: TextStyle(
          color: Colors.black,
          fontSize: 38,
          fontWeight: FontWeight.bold,
        ),
      ),
      centerTitle: true,
      backgroundColor: Colors.white,
      elevation: 6.0,
      shadowColor: Colors.grey,
    );
  }
}
