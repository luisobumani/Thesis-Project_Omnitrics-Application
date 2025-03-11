import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../home/homepage.dart';
import 'google_auth.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/tell_me.dart';


/// Helper function to determine if the user signed in with Google.
bool isGoogleUser(User? user) {
  if (user == null) return false;
  return user.providerData.any((provider) => provider.providerId == "google.com");
}

/// Handles the Google sign-in flow:
/// 1. Signs in with Google via FirebaseServices.
/// 2. Checks Firestore for a document under "users/{uid}".
/// 3. If no document exists, creates one with default empty fields.
/// 4. Checks if the user’s profile is complete (i.e. if firstName, lastName, birthdate, and gender are set).
/// 5. Redirects to the "Tell Me Who You Are" page if incomplete, or to the homepage if complete.
Future<void> handleGoogleSignIn(BuildContext context) async {
  print("Starting Google sign-in handler...");
  final firebaseServices = FirebaseServices();
  final UserCredential? userCredential = await firebaseServices.signInWithGoogle();

  if (userCredential == null) {
    print("Google sign-in was cancelled or failed.");
    return;
  }

  final User? user = userCredential.user;
  if (user == null) {
    print("No user returned after Google sign-in.");
    return;
  }

  final String uid = user.uid;
  print("User signed in with UID: $uid");

  final DocumentReference userDocRef =
      FirebaseFirestore.instance.collection("users").doc(uid);
  final DocumentSnapshot userDoc = await userDocRef.get();

  print("Does user document exist? ${userDoc.exists}");

  if (!userDoc.exists) {
    // Document does not exist; create a new one with default (empty) details.
    try {
      await userDocRef.set({
        'name': user.displayName ?? "",
        'email': user.email ?? "",
        'uid': uid,
        'firstName': "",
        'lastName': "",
        'birthdate': "",
        'gender': "",
      });
      print("Created new user document for UID: $uid");
    } catch (e) {
      print("Error creating user document: $e");
      return;
    }
    // New user: redirect to Tell Me Who You Are page.
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const TellMe()),
    );
    return;
  }

  // Document exists; check its data.
  final data = userDoc.data() as Map<String, dynamic>;
  print("User document data: $data");

  final bool isProfileIncomplete =
      (data['firstName']?.toString().isEmpty ?? true) ||
      (data['lastName']?.toString().isEmpty ?? true) ||
      (data['birthdate']?.toString().isEmpty ?? true) ||
      (data['gender']?.toString().isEmpty ?? true);

  print("Is profile incomplete? $isProfileIncomplete");

  if (isProfileIncomplete) {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const TellMe()),
    );
  } else {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }
}
