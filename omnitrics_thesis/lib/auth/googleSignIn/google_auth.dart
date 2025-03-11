import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleLogin = GoogleSignIn();

  /// Signs out from both Google and Firebase, then triggers the Google sign-in process.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Ensure previous sessions are signed out to force the account chooser.
      await googleLogin.signOut();
      await auth.signOut();

      // A short delay to ensure sign-out has finished.
      await Future.delayed(const Duration(seconds: 1));

      // Trigger the Google sign-in process.
      final GoogleSignInAccount? googleUser = await googleLogin.signIn();
      if (googleUser == null) {
        print("Google sign-in cancelled or no account selected.");
        return null;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in to Firebase with the Google credentials.
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print("Error during Google sign-in: ${e.toString()}");
      return null;
    }
  }

  Future<void> googleSignOut() async {
    await googleLogin.signOut();
    await auth.signOut();
  }
}
