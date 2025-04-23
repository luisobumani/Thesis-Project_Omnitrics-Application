import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/assesment/hue/hue_test.dart';
import 'package:omnitrics_thesis/getStarted/main_get_started.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omnitrics_thesis/auth/emailVerification/email_verification_page.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/tell_me.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_01.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_02.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_03.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_04.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_05.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_06.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_07.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_08.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_09.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_10.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_11.dart';
import 'package:omnitrics_thesis/assesment/ishihara/pages/ishihara_test_12.dart';
import 'package:omnitrics_thesis/assesment/ishihara/data/ishihara_test_model.dart';
import 'package:omnitrics_thesis/home/homepage.dart'; 

class AuthRedirect extends StatelessWidget {
  const AuthRedirect({Key? key}) : super(key: key);

  Future<bool> isProfileComplete(User user) async {
    final doc = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .get();
    if (!doc.exists) return false;
    final data = doc.data();
    return data != null &&
        data['firstName'] != null &&
        (data['firstName'] as String).isNotEmpty;
  }

  /// Load the last Ishihara page index (1–12) or 0 if none saved
  Future<int> _loadLastIshiharaPage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('ishiharaLastPage') ?? 0;
  }

  Future<bool> isHueComplete(User user) async {
    // Fetch all documents in the 'd15Tests' collection for the current user
    final querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid) // Get the document for the current user
        .collection('d15Tests') // Get the subcollection 'd15Tests'
        .get(); // Get all documents in the collection

    // Check if there are any documents in the 'd15Tests' collection
    if (querySnapshot.docs.isEmpty) return false;

    // Iterate through all the documents to find if any contains a valid 'diagnosis'
    for (var doc in querySnapshot.docs) {
      final data = doc.data();
      if (data != null &&
          data['diagnosis'] != null &&
          (data['diagnosis'] as String).isNotEmpty) {
        return true; // Return true if a valid diagnosis is found
      }
    }

    // If no valid diagnosis is found, return false
    return false;
  }

  Future<void> _resetTestState() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('d15TestState'); // Reset the saved D-15 test state
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // While checking auth state
        if (snapshot.connectionState != ConnectionState.active) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        // Not signed in
        if (!snapshot.hasData) {
          return MainGetStarted();
        }

        final user = snapshot.data!;
        // Email not verified yet
        if (!user.emailVerified) {
          return const VerificationScreen();
        }

        // Profile check
        return FutureBuilder<bool>(
          future: isProfileComplete(user),
          builder: (context, profileSnap) {
            if (profileSnap.connectionState != ConnectionState.done) {
              return const Scaffold(
                body: Center(child: CircularProgressIndicator()),
              );
            }
            if (profileSnap.hasData && profileSnap.data == true) {
              // Profile is complete → now decide: start Ishihara test
              return FutureBuilder<int>(
                future: _loadLastIshiharaPage(),
                builder: (context, pageSnap) {
                  if (pageSnap.connectionState != ConnectionState.done) {
                    return const Scaffold(
                      body: Center(child: CircularProgressIndicator()),
                    );
                  }
                  final lastPage = pageSnap.data ?? 0;
                  final model = IshiharaTestModel();

                  // If Ishihara test is not complete, proceed to Ishihara test page
                  if (lastPage >= 0 && lastPage < 12) {
                    switch (lastPage) {
                      case 0:
                        return IshiharaTest01(testModel: model);
                      case 1:
                        return IshiharaTest02(testModel: model);
                      case 2:
                        return IshiharaTest03(testModel: model);
                      case 3:
                        return IshiharaTest04(testModel: model);
                      case 4:
                        return IshiharaTest05(testModel: model);
                      case 5:
                        return IshiharaTest06(testModel: model);
                      case 6:
                        return IshiharaTest07(testModel: model);
                      case 7:
                        return IshiharaTest08(testModel: model);
                      case 8:
                        return IshiharaTest09(testModel: model);
                      case 9:
                        return IshiharaTest10(testModel: model);
                      case 10:
                        return IshiharaTest11(testModel: model);
                      case 11:
                        return IshiharaTest12(testModel: model);
                    }
                  }

                  // After completing Ishihara tests, move to Hue Test
                  return FutureBuilder<bool>(
                    future: isHueComplete(user),
                    builder: (context, hueSnap) {
                      if (hueSnap.connectionState != ConnectionState.done) {
                        return const Scaffold(
                          body: Center(child: CircularProgressIndicator()),
                        );
                      }

                      if (hueSnap.hasData && hueSnap.data == true) {
                        // Hue test complete, go to HomePage
                        return HomePage();
                      } else {
                        // If Hue test not complete, go to Hue Intro
                        return const ColorVisionApp();
                      }
                    },
                  );
                },
              );
            } else {
              // Profile incomplete → profile form
              return const ProfileForm();
            }
          },
        );
      },
    );
  }
}
