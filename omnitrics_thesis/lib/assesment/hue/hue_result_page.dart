import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/home/homepage.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
      body: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.0.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 50.h),
                Text('Your D‑15 Color Vision Results',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.bold,
                    )),
                SizedBox(height: 4.h),
                Text('Below are the scores from your recent test.',
                    style:
                        TextStyle(fontSize: 14.sp, color: Colors.grey.shade600)),
              ],
            ),
          ),

          SizedBox(height: 100.h),

          // Card with stats
          Card(
            elevation: 4.h,
            margin: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
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
                      const Icon(Icons.compare_sharp,
                          size: 28, color: Colors.deepPurple),
                      SizedBox(width: 8.w),
                      Text(
                        '${angleDeg.toStringAsFixed(1)}°',
                        style: TextStyle(
                          fontSize: 28.sp,
                          fontWeight: FontWeight.bold
                        )
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
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'TES',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                            Text(
                              tes.toStringAsFixed(1),
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.h),

                  // C‑Index & S‑Index
                  Row(
                    children: [
                      Expanded(
                        child: _StatTile(
                          label: 'C‑Index',
                          value: cIndex.toStringAsFixed(2),
                        ),
                      ),
                      SizedBox(width: 16.w),
                      Expanded(
                        child: _StatTile(
                          label: 'S‑Index',
                          value: sIndex.toStringAsFixed(2),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          SizedBox(
            height: 75.h,
          ),

          ElevatedButton(
            style: ButtonStyle(
              foregroundColor: WidgetStateProperty.all(Colors.white),
              backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                if (states.contains(WidgetState.pressed)) {
                  return Colors.deepPurple.shade900;
                }
                return Colors.deepPurple.shade400;
              }),
              elevation: WidgetStateProperty.all<double>(10.0.h),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              padding: WidgetStateProperty.all<EdgeInsetsGeometry>(
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h)
              )
            ),
            onPressed: () {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => HomePage()));
            },
            child: Text('Continue to Home'),
          )
        ],
      ),
    );
  }
}

/// A small widget to show label + big number
class _StatTile extends StatelessWidget {
  final String label;
  final String value;

  const _StatTile({
    Key? key,
    required this.label,
    required this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontSize: 12.sp
          )
        ),
        SizedBox(height: 4.h),
        Text(
          value,
          style: TextStyle(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold
          )
        ),
      ],
    );
  }
}
