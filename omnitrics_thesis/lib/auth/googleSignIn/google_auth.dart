import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseServices {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleLogin = GoogleSignIn();

  // This method signs the user out first to ensure the Google account selector appears.
  Future<UserCredential?> signInWithGoogle() async {
    try {
      // Sign out from Google and Firebase to ensure the account chooser will appear
      await googleLogin.signOut();
      await auth.signOut();  // Ensure Firebase signs out too

      // Delay added to ensure the sign-out process is complete
      await Future.delayed(const Duration(seconds: 1));

      // Trigger the Google sign-in process and show the account picker
      final GoogleSignInAccount? googleUser = await googleLogin.signIn();
      
      // If the user closed the account chooser or didn't select an account, `googleUser` will be null
      if (googleUser == null) {
        print("No account selected or account chooser closed.");
        return null;  // If no account is selected, return null and don't proceed
      }

      // Proceed if the user selected an account
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the Google credentials and return the UserCredential
      return await auth.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      print("Error during Google sign-in: ${e.toString()}");
      return null;  // If there is an error, return null
    }
  }

  // This method signs out the user from both Google and Firebase.
  Future<void> googleSignOut() async {
    await googleLogin.signOut();
    await auth.signOut();
  }
}
