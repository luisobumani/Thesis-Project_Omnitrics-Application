import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthServices {
  // Storing data in cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  // For authentication
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> userSignup(
      {required String email,
       required String password,         
       required String name}) 
      async {
    String res = " Some error occured ";
    try {
      if (email.isNotEmpty || password.isNotEmpty || name.isNotEmpty) { 
      UserCredential credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // The database stores the name, email, and the user id
      await _firestore.collection("users").doc(credential.user!.uid).set({
        'name': name,
        "email": email,
        'uid': credential.user!.uid,
      });
      // Message for successful signup
      res = "Signup successful!";
      }
    } catch (e) {
      return e.toString();
    }
    return res;
  }

  //Login
  Future<String> userLogin({
    required String email,
    required String password,
  }) async {
    String res = "Some error occured";
    try{
      if (email.isNotEmpty || password.isNotEmpty) {
        await _auth.signInWithEmailAndPassword(
          email: email, 
          password: password
        );
        res = "Login successful!";
      } else {
        res = "Please enter all the fields";
      }
    }catch(e){
      return e.toString();
    }
    return res;
  }
  //logout
  Future<void> signOut() async {
    await _auth.signOut();
  }
}
