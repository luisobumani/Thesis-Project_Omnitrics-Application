import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class D15TestService {
  /// Saves the D-15 test result for the current user under
  /// /users/{uid}/d15Tests/{autoId}
  static Future<void> saveTestResult({
    required double angleDeg,
    required double tes,
    required double cIndex,
    required double sIndex,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'NO_CURRENT_USER',
        message: 'Cannot save test results: no user is signed in.',
      );
    }

    final testDoc = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('d15Tests')
        .doc(); // auto‐ID

    await testDoc.set({
      'dateTaken': FieldValue.serverTimestamp(),
      'angleDeg': angleDeg,
      'tes': tes,
      'cIndex': cIndex,
      'sIndex': sIndex,
    });
  }
}
