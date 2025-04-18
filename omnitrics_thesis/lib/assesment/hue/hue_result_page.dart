import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/homepage.dart';

/// A simple results page for the D-15 Color Vision Test.
class D15ResultsPage extends StatelessWidget {
  final double angleDeg;
  final double tes;
  final double cIndex;
  final double sIndex;

  const D15ResultsPage({
    Key? key,
    required this.angleDeg,
    required this.tes,
    required this.cIndex,
    required this.sIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Results'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Angle: ${angleDeg.toStringAsFixed(1)}°',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'Total Error (TES): ${tes.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'C-index: ${cIndex.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              'S-index: ${sIndex.toStringAsFixed(2)}',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const Spacer(),
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Back'),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => HomePage()));
                    },
                    child: const Text('Home'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
