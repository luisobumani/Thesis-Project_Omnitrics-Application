import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnitrics_thesis/assesment/ishihara/data/plates_config.dart';
import 'package:omnitrics_thesis/assesment/ishihara/data/ishihara_test_model.dart';

/// Evaluates the Ishihara test results and saves them in Firestore.
Future<void> evaluateAndSaveIshiharaTest(IshiharaTestModel testModel) async {
  int correctCount = 0;
  int redGreenCount = 0;
  int totalColorCount = 0;
  
  // Tally counts based on each test plate configuration.
  for (int i = 0; i < testConfigs.length; i++) {
    final config = testConfigs[i];
    final answer = testModel.answers[i];

    if(answer == config.correctAnswerIndex){
      correctCount++;
    }

    if (config.redGreenAnswerIndex != null && answer == config.redGreenAnswerIndex) {
      redGreenCount++;
    }
    if (config.totalColorAnswerIndex != null && answer == config.totalColorAnswerIndex) {
      totalColorCount++;
    }
  }

  // Example decision logic (adjust thresholds as needed)
  String diagnosis;
  if (redGreenCount > totalColorCount && redGreenCount > (testConfigs.length / 2)) {
    diagnosis = "Red-Green Color Blindness";
  } else if (totalColorCount > redGreenCount && totalColorCount > (testConfigs.length / 2)) {
    diagnosis = "Total Color Blindness";
  } else {
    diagnosis = "Normal or Inconclusive";
  }

  // Save results to Firestore under the current user's "ishiharaTests" subcollection
  final user = FirebaseAuth.instance.currentUser;
  if (user == null) {
    // Optionally handle unauthenticated state.
    return;
  }
  final userId = user.uid;
  DocumentReference testDoc = FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('ishiharaTests')
      .doc();

  await testDoc.set({
    'dateTaken': FieldValue.serverTimestamp(),
    'answers': testModel.answers,
    'diagnosis': diagnosis,
    'score': {
      'correctCount': correctCount,
      'redGreenCount': redGreenCount,
      'totalColorCount': totalColorCount,
    },
  });
}
