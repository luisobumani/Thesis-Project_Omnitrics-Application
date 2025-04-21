import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:omnitrics_thesis/assesment/intro/intro_hue.dart';
import 'package:omnitrics_thesis/getStarted/main_get_started.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:omnitrics_thesis/auth/sign-in/login.dart';
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
              // Profile is complete → now decide: resume Ishihara or go Home
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

                  // 0–11 => always go to the corresponding Ishihara page
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

                  // lastPage >= 12 => Ishihara is done, go to Hue intro
                  return const IntroHue();
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
