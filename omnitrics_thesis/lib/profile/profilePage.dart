import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/profile/Widget/edit_button.dart';
import 'package:omnitrics_thesis/profile/Widget/logoutBtn.dart';
import 'package:omnitrics_thesis/profile/Widget/prof_details_main.dart';
import 'package:omnitrics_thesis/profile/Widget/prof_info.dart';

import '../home/homepage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Get the current user id from FirebaseAuth
    final String uid = FirebaseAuth.instance.currentUser!.uid;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBarProf(context),
      body: SafeArea(
        child: FutureBuilder<DocumentSnapshot>(
          future:
              FirebaseFirestore.instance.collection("users").doc(uid).get(),
          builder: (context, snapshot) {
            // Show a loading spinner while waiting for data
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            // Handle error or missing data
            if (!snapshot.hasData || snapshot.data == null) {
              return const Center(child: Text("No data found."));
            }
            // Extract the data as a Map
            final data =
                snapshot.data!.data() as Map<String, dynamic>? ?? <String, dynamic>{};

            return SingleChildScrollView(
              child: Column(
                children: [
                  // Pass the loaded data to each widget
                  ProfDetailsMain(data: data),
                  ProfInfo(data: data),
                  EditButton(),
                  logoutBtn(context),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  AppBar appBarProf(BuildContext context) {
    return AppBar(
      leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: Colors.white),
      onPressed: () {
        // Navigate to HomePage (or any route you want)
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const HomePage()),
        );
      },
    ),
      title: const Text(
        'My Profile',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.deepPurple,
      centerTitle: true,
    );
  }
}
