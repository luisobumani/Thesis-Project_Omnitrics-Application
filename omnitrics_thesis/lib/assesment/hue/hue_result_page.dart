import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/homepage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// A simple results page for the D-15 Color Vision Test.
class D15ResultsPage extends StatelessWidget {
  final double angleDeg;
  final double tes;
  final double cIndex;
  final double sIndex;
  final double protanError;
  final double deutanError;
  final double tritanError;
  final String diagnosis;

  const D15ResultsPage({
    Key? key,
    required this.angleDeg,
    required this.tes,
    required this.cIndex,
    required this.sIndex,
    required this.protanError,
    required this.deutanError,
    required this.tritanError,
    required this.diagnosis,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Test Results',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.0.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20.h),
                  Text(
                    'Your D-15 Color Vision Results',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.deepPurple.shade800,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'Below are the scores from your recent test.',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  // Diagnosis
                  SizedBox(height: 12.h),
                  Text(
                    'Diagnosis: $diagnosis',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 20.h),

            // Stats Card
            Card(
              elevation: 4,
              margin: EdgeInsets.symmetric(horizontal: 24.w),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(24.h),
                child: Column(
                  children: [
                    // Angle row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.compare_sharp,
                          size: 28,
                          color: Colors.deepPurple,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${angleDeg.toStringAsFixed(1)}°',
                          style: TextStyle(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 30.h),

                    // TES gauge
                    SizedBox(
                      width: 100.w,
                      height: 100.h,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 150.w,
                            height: 150.h,
                            child: CircularProgressIndicator(
                              strokeWidth: 8.w,
                              value: (tes.clamp(0, 100)) / 100,
                              backgroundColor: Colors.grey.shade300,
                              color: Colors.deepPurple,
                            ),
                          ),
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                'TES',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall!
                                    .copyWith(color: Colors.deepPurple),
                              ),
                              Text(
                                tes.toStringAsFixed(1),
                                style: TextStyle(
                                  fontSize: 16.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 30.h),

                    // C-Index & S-Index
                    Row(
                      children: [
                        Expanded(
                          child: _StatTile(
                            label: 'C-Index',
                            value: cIndex.toStringAsFixed(2),
                            valueColor: Colors.deepPurple,
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: _StatTile(
                            label: 'S-Index',
                            value: sIndex.toStringAsFixed(2),
                            valueColor: Colors.deepPurple,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: 24.h),

            // Definitions Card
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.w),
              child: Card(
                color: Colors.deepPurple.shade50,
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Padding(
                  padding: EdgeInsets.all(16.h),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Key Definitions',
                        style: TextStyle(
                          fontSize: 18.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.deepPurple.shade800,
                        ),
                      ),
                      SizedBox(height: 12.h),
                      _DefinitionTile(
                        term: 'Total Error Score (TES)',
                        description: 'Counts how many mistakes were made overall.',
                        termColor: Colors.deepPurple,
                      ),
                      _DefinitionTile(
                        term: 'Confusion Index (C-index)',
                        description: 'Counts how many of those mistakes all follow the same color mix-up. A low number means mistakes are random; a higher number means the same colors keep getting swapped.',
                        termColor: Colors.deepPurple,
                      ),
                      _DefinitionTile(
                        term: 'Selectivity Index (S-index)',
                        description: 'Counts the mistakes that don’t fit that main mix-up pattern, basically the “leftover” random slips.',
                        termColor: Colors.deepPurple,
                      ),
                      _DefinitionTile(
                        term: 'Confusion Angle',
                        description: 'Tells which color you tend to mix up most: red, green, or blue. If you have normal color vision, there isn’t one main color you confuse, so this doesn’t apply.',
                        termColor: Colors.deepPurple,
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        'Reference Values:',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.deepPurple.shade700,
                        ),
                      ),
                      SizedBox(height: 6.h),
                      _ReferenceTile(
                        label: 'Normal C-index',
                        value: '1.00',
                      ),
                      _ReferenceTile(
                        label: 'Normal S-index',
                        value: '1.38',
                      ),
                      _ReferenceTile(
                        label: 'Normal angle',
                        value: '62°',
                      ),
                      _ReferenceTile(
                        label: 'Protan/Deutan angle',
                        value: '+9.7° / -8.8°',
                      ),
                      _ReferenceTile(
                        label: 'Tritan angle',
                        value: '-86.8°',
                      ),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: 32.h),

            Center(
              child: ElevatedButton(
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.white),
                  backgroundColor: MaterialStateProperty.resolveWith<Color>(
                    (states) => states.contains(MaterialState.pressed)
                        ? Colors.deepPurple.shade900
                        : Colors.deepPurple.shade400,
                  ),
                  elevation: MaterialStateProperty.all<double>(10.0),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                  ),
                  padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                    EdgeInsets.symmetric(horizontal: 24.w, vertical: 14.h),
                  ),
                ),
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => HomePage()),
                    (route) => false,
                  );
                },
                child: const Text('Continue to Home'),
              ),
            ),

            SizedBox(height: 24.h),
          ],
        ),
      ),
    );
  }
}

/// A small widget to show label + big number
class _StatTile extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _StatTile({
    Key? key,
    required this.label,
    required this.value,
    this.valueColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(fontSize: 12.sp, color: Colors.deepPurple),
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(fontSize: 24.sp, fontWeight: FontWeight.bold, color: valueColor),
        ),
      ],
    );
  }
}

/// A widget to display definition term and its description
class _DefinitionTile extends StatelessWidget {
  final String term;
  final String description;
  final Color termColor;

  const _DefinitionTile({
    Key? key,
    required this.term,
    required this.description,
    this.termColor = Colors.black87,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12.h),
      child: RichText(
        text: TextSpan(
          style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          children: [
            TextSpan(
              text: '$term: ',
              style: TextStyle(fontWeight: FontWeight.w600, color: termColor),
            ),
            TextSpan(text: description),
          ],
        ),
      ),
    );
  }
}

/// A widget to display reference label and value
class _ReferenceTile extends StatelessWidget {
  final String label;
  final String value;

  const _ReferenceTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.h),
      child: Row(
        children: [
          Text(
            '• ',
            style: TextStyle(fontSize: 14.sp, color: Colors.deepPurple),
          ),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: TextStyle(fontSize: 14.sp, color: Colors.black87),
                children: [
                  TextSpan(
                    text: '$label: ',
                    style: TextStyle(fontWeight: FontWeight.w600, color: Colors.deepPurple),
                  ),
                  TextSpan(text: value),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
