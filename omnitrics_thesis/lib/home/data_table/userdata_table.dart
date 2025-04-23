import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_circle_chart/flutter_circle_chart.dart';

/// A widget that fetches the most recent D-15 test from Firestore
/// and displays a diagnosis + receptor-error circle chart.
class UserDataChart extends StatelessWidget {
  const UserDataChart({Key? key}) : super(key: key);

  /// Returns a Map containing protan, deutan, tritan and diagnosis.
  Future<Map<String, dynamic>> _fetchResult() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) throw Exception('No user signed in');

    final snap = await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .collection('d15Tests')
        .orderBy('dateTaken', descending: true)
        .limit(1)
        .get();

    if (snap.docs.isEmpty) throw Exception('No test data found');

    final data = snap.docs.first.data();
    return {
      'protan':    (data['protanError'] as num).toDouble(),
      'deutan':    (data['deutanError'] as num).toDouble(),
      'tritan':    (data['tritanError'] as num).toDouble(),
      'diagnosis': data['diagnosis'] as String,
    };
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchResult(),
      builder: (context, snap) {
        if (snap.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snap.hasError) {
          return Center(child: Text('Error: ${snap.error}'));
        }

        // Extract both the errors and the diagnosis:
        final result    = snap.data!;
        final protan    = result['protan']    as double;
        final deutan    = result['deutan']    as double;
        final tritan    = result['tritan']    as double;
        final diagnosis = result['diagnosis'] as String;

        return Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              // Display the fetched diagnosis:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  diagnosis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              // Now the CircleChart with your three errors:
              CircleChart(
                chartType: CircleChartType.gradient,
                backgroundColor: Colors.transparent,
                items: [
                  CircleChartItemData(
                    color: Colors.red,
                    value: protan,
                    name: 'PROTANOPIA',
                    description:
                        'Red channel error → ${protan.toStringAsFixed(1)}',
                  ),
                  CircleChartItemData(
                    color: Colors.green,
                    value: deutan,
                    name: 'DEUTERANOPIA',
                    description:
                        'Green channel error → ${deutan.toStringAsFixed(1)}',
                  ),
                  CircleChartItemData(
                    color: Colors.blue,
                    value: tritan,
                    name: 'TRITANOPIA',
                    description:
                        'Blue channel error → ${tritan.toStringAsFixed(1)}',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
