import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // Firestore instance
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;


  Future<void> sendEmailVerificationLink()async{
    try{
      await _auth.currentUser?.sendEmailVerification();
    } catch(e) {
      print(e.toString());
    } 
  }  
  
  Future<String> userSignup({
    required String email,
    required String password,
    required String name,
  }) async {
    String res = "Some error occurred";
    try {
      // Ensure all fields are provided
      if (email.isNotEmpty && password.isNotEmpty && name.isNotEmpty) { 
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );
        // Create a user document with placeholders for additional info
        await _firestore.collection("users").doc(credential.user!.uid).set({
          'name': name,
          "email": email,
          'firstName': "",
          'lastName': "",
          'birthdate': "",
          'gender': "",
          'uid': credential.user!.uid,
        });
        res = "Please verify your email.";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  // Login method remains unchanged
  Future<String> userLogin({
    required String email,
    required String password,
  }) async {
    String res = "Some error occurred";
    try {
      if (email.isNotEmpty && password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password,
        );
        res = "Login successful!";
      } else {
        res = "Please enter all the fields";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  // Logout method remains unchanged
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
