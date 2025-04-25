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
    final qs = await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .collection('d15Tests')
      .get();
    return qs.docs.any((d) {
      final diag = (d.data()['diagnosis'] as String?) ?? '';
      return diag.isNotEmpty;
    });
  }

  Future<bool> isIshiharaComplete(User user) async {
    final qs = await FirebaseFirestore.instance
      .collection("users")
      .doc(user.uid)
      .collection('ishiharaTests')
      .get();
    return qs.docs.any((d) {
      final diag = (d.data()['diagnosis'] as String?) ?? '';
      return diag.isNotEmpty;
    });
  }

  Future<void> _clearIshiharaState() async {
    final p = await SharedPreferences.getInstance();
    await p.remove('ishiharaLastPage');
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
        if (!user.emailVerified) {
          return const VerificationScreen();
        }

        return FutureBuilder<bool>(
          future: isProfileComplete(user),
          builder: (context, profSnap) {
            if (profSnap.connectionState != ConnectionState.done) {
              return const Scaffold(body: Center(child: CircularProgressIndicator()));
            }
            if (profSnap.data != true) {
              return const ProfileForm();
            }

            // Profile is complete → now check Ishihara diagnosis in DB
            return FutureBuilder<bool>(
              future: isIshiharaComplete(user),
              builder: (context, ishSnap) {
                if (ishSnap.connectionState != ConnectionState.done) {
                  return const Scaffold(body: Center(child: CircularProgressIndicator()));
                }

                if (ishSnap.data == true) {
                  // Already diagnosed → clear local state & move on to Hue
                  _clearIshiharaState();
                  return FutureBuilder<bool>(
                    future: isHueComplete(user),
                    builder: (ctx, hueSnap) {
                      if (hueSnap.connectionState != ConnectionState.done) {
                        return const Scaffold(body: Center(child: CircularProgressIndicator()));
                      }
                      return hueSnap.data == true
                        ? HomePage()                   
                        : const ColorVisionApp();    
                    },
                  );
                }

                // No Ishihara diagnosis yet → resume Ishihara flow
                return FutureBuilder<int>(
                  future: _loadLastIshiharaPage(),
                  builder: (ctx, pageSnap) {
                    if (pageSnap.connectionState != ConnectionState.done) {
                      return const Scaffold(body: Center(child: CircularProgressIndicator()));
                    }
                    final last = pageSnap.data!;
                    final model = IshiharaTestModel();
                    switch (last) {
                      case 0:  return IshiharaTest01(testModel: model);
                      case 1:  return IshiharaTest02(testModel: model);
                      case 2:  return IshiharaTest03(testModel: model);
                      case 3:  return IshiharaTest04(testModel: model);
                      case 4:  return IshiharaTest05(testModel: model);
                      case 5:  return IshiharaTest06(testModel: model);
                      case 6:  return IshiharaTest07(testModel: model);
                      case 7:  return IshiharaTest08(testModel: model);
                      case 8:  return IshiharaTest09(testModel: model);
                      case 9:  return IshiharaTest10(testModel: model);
                      case 10: return IshiharaTest11(testModel: model);
                      case 11: return IshiharaTest12(testModel: model);
                      default: // last >= 12 or invalid
                        return FutureBuilder<bool>(
                          future: isHueComplete(user),
                          builder: (c, hueSnap2) {
                            if (hueSnap2.connectionState != ConnectionState.done) {
                              return const Scaffold(body: Center(child: CircularProgressIndicator()));
                            }
                            return hueSnap2.data == true
                              ? HomePage()
                              : const ColorVisionApp();
                          },
                        );
                    }
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
