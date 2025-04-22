import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:omnitrics_thesis/assesment/hue/hue_result_page.dart';
import 'package:omnitrics_thesis/assesment/hue/services/d15_test_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ColorVisionApp extends StatelessWidget {
  const ColorVisionApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'D-15 Color Vision Test',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const ColorTestPage(),
    );
  }
}

class ColorTestPage extends StatefulWidget {
  const ColorTestPage({Key? key}) : super(key: key);

  @override
  _ColorTestPageState createState() => _ColorTestPageState();
}

class _ColorTestPageState extends State<ColorTestPage> {
  // Fixed pilot cap color and coordinates
  final Color pilotColor = const Color.fromRGBO(55, 129, 193, 1);
  final Color lastColor = const Color.fromRGBO(128, 115, 178, 1);
  static const Offset pilotUV = Offset(-21.54, -38.39);

  // CIE L*u*v* coordinates for caps 1-15
  final List<Offset> uvCoords = const [
    Offset(-23.26, -25.56),
    Offset(-22.41, -15.53),
    Offset(-23.11, -7.45),
    Offset(-22.45, 1.10),
    Offset(-21.67, 7.35),
    Offset(-14.08, 18.74),
    Offset(-2.72, 28.13),
    Offset(14.84, 31.13),
    Offset(23.87, 26.35),
    Offset(31.82, 14.76),
    Offset(31.42, 6.99),
    Offset(29.79, 0.10),
    Offset(26.64, -9.38),
    Offset(22.92, -18.65),
    Offset(11.20, -24.61),
  ];

  // Display colors for caps 1-15
  final List<Color> capColors = const [
    const Color.fromRGBO(53, 131, 180, 1),
    const Color.fromRGBO(59, 132, 167, 1),
    const Color.fromRGBO(57, 133, 156, 1),
    const Color.fromRGBO(59, 134, 144, 1),
    const Color.fromRGBO(63, 135, 130, 1),
    const Color.fromRGBO(88, 132, 115, 1),
    const Color.fromRGBO(108, 129, 100, 1),
    const Color.fromRGBO(131, 123, 93, 1),
    const Color.fromRGBO(144, 118, 96, 1),
    const Color.fromRGBO(158, 110, 111, 1),
    const Color.fromRGBO(159, 109, 124, 1),
    const Color.fromRGBO(156, 109, 137, 1),
    const Color.fromRGBO(146, 112, 153, 1),
    const Color.fromRGBO(143, 111, 164, 1),
    const Color.fromRGBO(128, 115, 178, 1),
  ];

  // Slots for caps 1-15
  List<int?> placed = List<int?>.filled(15, null);

  // Shuffled palette order
  late List<int> palette;

  // Scoring results
  double? angleDeg, Rmaj, Rmin, TES, Sindex, Cindex;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _resetPalette();
  }

  void _resetPalette() {
    // generate and shuffle palette 1-15
    palette = List<int>.generate(15, (i) => i + 1);
    palette.shuffle();
  }

  void _computeScores() {
    final order =
        <Offset>[pilotUV] + placed.map((c) => uvCoords[c! - 1]).toList();
    final deltaU = <double>[];
    final deltaV = <double>[];
    for (var i = 1; i < order.length; i++) {
      deltaU.add(order[i].dx - order[i - 1].dx);
      deltaV.add(order[i].dy - order[i - 1].dy);
    }
    final U2 = deltaU.fold<double>(0, (s, du) => s + du * du);
    final V2 = deltaV.fold<double>(0, (s, dv) => s + dv * dv);
    double UV = 0;
    for (var i = 0; i < deltaU.length; i++) UV += deltaU[i] * deltaV[i];
    final theta = 0.5 * math.atan2(2 * UV, U2 - V2);
    angleDeg = theta * 180 / math.pi;
    double moment(double phi) {
      var sum = 0.0;
      for (var i = 0; i < deltaU.length; i++) {
        final d = deltaV[i] * math.cos(phi) - deltaU[i] * math.sin(phi);
        sum += d * d;
      }
      return sum;
    }

    var Imaj = moment(theta);
    var Imin = moment(theta + math.pi / 2);
    if (Imin > Imaj) {
      final t = Imaj;
      Imaj = Imin;
      Imin = t;
    }
    final H = deltaU.length;
    Rmaj = math.sqrt(Imaj / H);
    Rmin = math.sqrt(Imin / H);
    TES = math.sqrt(Rmaj! * Rmaj! + Rmin! * Rmin!);
    Sindex = Rmaj! / Rmin!;
    const perfect = 9.234669;
    Cindex = Rmaj! / perfect;
  }

  void _resetTest() {
    setState(() {
      placed = List<int?>.filled(15, null);
      angleDeg = Rmaj = Rmin = TES = Sindex = Cindex = null;
      _submitted = false;
      _resetPalette();
    });
  }

  Future<void> _submit() async {
    if (placed.contains(null)) return;

    _computeScores();

    try {
      await D15TestService.saveTestResult(
        angleDeg: angleDeg!,
        tes: TES!,
        cIndex: Cindex!,
        sIndex: Sindex!,
      );

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(builder: (_) => D15ResultsPage(
        angleDeg: angleDeg!, 
        tes: TES!, 
        cIndex: Cindex!, 
        sIndex: Sindex!,
        )
      )
    );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error Saving Results')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final available = palette.where((c) => !placed.contains(c)).toList();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'D-15 Color Vision Test',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Colors.deepPurple.shade700,
              Colors.deepPurple.shade400,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight),
          ),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    Text(
                      'First Item:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: pilotColor,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  width: 220.w,
                ),
                Column(
                  children: [
                    Text(
                      'Last Item:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8.h),
                    Container(
                      width: 40.w,
                      height: 40.h,
                      decoration: BoxDecoration(
                        color: lastColor,
                        border: Border.all(color: Colors.black),
                      ),
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(15, (i) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: DragTarget<int>(
                              onAccept: (c) {
                                if (!_submitted) {
                                  setState(() => placed[i] = c);
                                }
                              },
                              builder: (ctx, cand, rj) {
                                final cap = placed[i];
                                final color = cap == null
                                    ? Colors.grey[300]
                                    : capColors[cap - 1];
                                return Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: color,
                                    border: Border.all(color: Colors.black),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                  ),

                  SizedBox(width: 16.w),

                  // Right: Draggable palette column
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: available.map((c) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: Draggable<int>(
                              data: c,
                              feedback: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: capColors[c - 1],
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                              childWhenDragging: Container(
                                width: 40.w,
                                height: 40.h,
                                color: Colors.grey[200],
                              ),
                              child: Container(
                                width: 40.w,
                                height: 40.h,
                                decoration: BoxDecoration(
                                  color: capColors[c - 1],
                                  border: Border.all(color: Colors.black),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.red.shade900;
                        }
                        return Colors.red;
                      }),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      elevation: WidgetStateProperty.all<double>(10.0.h),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    onPressed: _resetTest,
                    child: Text('Reset',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold
                    ),),
                  ),
                  SizedBox(width: 70.w),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: WidgetStateProperty.resolveWith<Color>(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return Colors.deepPurple.shade900;
                        }
                        return Colors.deepPurple.shade400;
                      }),
                      foregroundColor: WidgetStateProperty.all(Colors.white),
                      elevation: WidgetStateProperty.all<double>(10.0.h),
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    onPressed: _submit,
                    child: Text('Submit',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold
                    )),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            if (_submitted && Cindex != null) ...[
              Text('Angle: ${angleDeg!.toStringAsFixed(1)}°'),
              Text('C-index: ${Cindex!.toStringAsFixed(2)}'),
              Text('S-index: ${Sindex!.toStringAsFixed(2)}'),
              Text('Total Error: ${TES!.toStringAsFixed(1)}'),
            ],
          ],
        ),
      ),
    );
  }
}
