import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/assesment/hue/hue_result_page.dart';
import 'package:omnitrics_thesis/assesment/hue/services/d15_test_service.dart';

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
  // Fixed pilot cap
  static const Offset pilotUV = Offset(-21.54, -38.39);
  final Color pilotColor = const Color.fromRGBO(55, 129, 193, 1);

  // L*u*v* for caps 1–15
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

  final List<Color> capColors = const [
    Color.fromRGBO(53, 131, 180, 1),
    Color.fromRGBO(59, 132, 167, 1),
    Color.fromRGBO(57, 133, 156, 1),
    Color.fromRGBO(59, 134, 144, 1),
    Color.fromRGBO(63, 135, 130, 1),
    Color.fromRGBO(88, 132, 115, 1),
    Color.fromRGBO(108, 129, 100, 1),
    Color.fromRGBO(131, 123, 93, 1),
    Color.fromRGBO(144, 118, 96, 1),
    Color.fromRGBO(158, 110, 111, 1),
    Color.fromRGBO(159, 109, 124, 1),
    Color.fromRGBO(156, 109, 137, 1),
    Color.fromRGBO(146, 112, 153, 1),
    Color.fromRGBO(143, 111, 164, 1),
    Color.fromRGBO(128, 115, 178, 1),
  ];

  List<int?> placed = List<int?>.filled(15, null);
  late List<int> palette;

  // Standard D-15 metrics
  double? angleDeg, Rmaj, Rmin, TES, Sindex, Cindex;

  // Receptor-axis errors (method 2)
  double? protanError, deutanError, tritanError;

  @override
  void initState() {
    super.initState();
    _resetPalette();
  }

  void _resetPalette() {
    // Always generate in order for testing; shuffle() is commented out
    palette = List<int>.generate(15, (i) => i + 1);
    palette.shuffle();
  }

  void _computeScores() {
    // 1) Build list
    final order = <Offset>[pilotUV]
      ..addAll(placed.map((c) => uvCoords[c! - 1]));

    // 2) Δu, Δv
    final deltaU = <double>[], deltaV = <double>[];
    for (var i = 1; i < order.length; i++) {
      deltaU.add(order[i].dx - order[i - 1].dx);
      deltaV.add(order[i].dy - order[i - 1].dy);
    }

    // 3) S1, S2, S3
    final S1 = deltaU.fold(0.0, (s, du) => s + du * du);
    final S2 = deltaV.fold(0.0, (s, dv) => s + dv * dv);
    final S3 = List.generate(deltaU.length, (i) => deltaU[i] * deltaV[i])
        .fold(0.0, (s, v) => s + v);

    // 4) θ
    final theta = 0.5 * math.atan2(2 * S3, S1 - S2);
    angleDeg = theta * 180 / math.pi;

    // 5) TES, S-index, C-index
    double moment(double phi) {
      var sum = 0.0;
      for (var i = 0; i < deltaU.length; i++) {
        final d = deltaV[i] * math.cos(phi) - deltaU[i] * math.sin(phi);
        sum += d * d;
      }
      return sum;
    }

    var Imaj = moment(theta), Imin = moment(theta + math.pi / 2);
    if (Imin > Imaj) Imaj = Imaj + Imin - (Imin = Imaj);
    final H = deltaU.length;
    Rmaj = math.sqrt(Imaj / H);
    Rmin = math.sqrt(Imin / H);
    TES = math.sqrt(Rmaj! * Rmaj! + Rmin! * Rmin!);
    Sindex = Rmaj! / Rmin!;
    const perfectMaj = 9.234669;
    Cindex = Rmaj! / perfectMaj;

    // 6) Projection axes
    const pDeg = 9.7, dDeg = -8.8, tDeg = -86.8;
    final pA = pDeg * math.pi / 180;
    final dA = dDeg * math.pi / 180;
    final tA = tDeg * math.pi / 180;

    final wP = (math.cos(theta - pA)).abs();
    final wD = (math.cos(theta - dA)).abs();
    final wT = (math.cos(theta - tA)).abs();
    final sumW = wP + wD + wT;

    // 7) Gate on C-index < 1.2
    if (Cindex! < 1.2 || sumW == 0.0) {
      protanError = deutanError = tritanError = 0.0;
    } else {
      protanError = 100 * wP / sumW;
      deutanError = 100 * wD / sumW;
      tritanError = 100 * wT / sumW;
    }
  }

  void _resetTest() {
    setState(() {
      placed = List<int?>.filled(15, null);
      angleDeg = Rmaj = Rmin = TES = Sindex = Cindex = null;
      protanError = deutanError = tritanError = null;
      _resetPalette();
    });
  }

  Future<void> _submit() async {
    if (placed.contains(null)) return;

    _computeScores();

    late String diagnosis;
    if (Cindex! < 1.2) {
      diagnosis = 'Normal color vision';
    } else if (protanError! >= deutanError! && protanError! >= tritanError!) {
      diagnosis = 'Protan-type confusion';
    } else if (deutanError! >= protanError! && deutanError! >= tritanError!) {
      diagnosis = 'Deutan-type confusion';
    } else {
      diagnosis = 'Tritan-type confusion';
    }

    try {
      await D15TestService.saveTestResult(
        angleDeg: angleDeg!,
        tes: TES!,
        cIndex: Cindex!,
        sIndex: Sindex!,
        protanError: protanError!,
        deutanError: deutanError!,
        tritanError: tritanError!,
        diagnosis: diagnosis,
      );

      if (!mounted) return;
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) => D15ResultsPage(
              angleDeg: angleDeg!,
              tes: TES!,
              cIndex: Cindex!,
              sIndex: Sindex!,
              protanError: protanError!,
              deutanError: deutanError!,
              tritanError: tritanError!,
              diagnosis: diagnosis),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error saving results')));
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
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('First Item:',
                style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 8.h),
            Container(
              width: 40.w,
              height: 40.h,
              decoration: BoxDecoration(
                color: pilotColor,
                border: Border.all(color: Colors.black),
              ),
            ),
            SizedBox(height: 24.h),
            Expanded(
              child: Row(
                children: [
                  // slots
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: List.generate(15, (i) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 4.h),
                            child: DragTarget<int>(
                              onAccept: (c) => setState(() => placed[i] = c),
                              builder: (_, __, ___) {
                                final cap = placed[i];
                                return Container(
                                  width: 40.w,
                                  height: 40.h,
                                  decoration: BoxDecoration(
                                    color: cap == null
                                        ? Colors.grey[300]
                                        : capColors[cap - 1],
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
                  // palette
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
                    onPressed: _resetTest,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => states.contains(MaterialState.pressed)
                            ? Colors.red.shade900
                            : Colors.red,
                      ),
                      elevation: MaterialStateProperty.all(10.0.h),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    child: Text(
                      'Reset',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
                  ),
                  SizedBox(width: 70.w),
                  ElevatedButton(
                    onPressed: _submit,
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith(
                        (states) => states.contains(MaterialState.pressed)
                            ? Colors.deepPurple.shade900
                            : Colors.deepPurple.shade400,
                      ),
                      elevation: MaterialStateProperty.all(10.0.h),
                      shape: MaterialStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                    ),
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          fontSize: 15.sp, fontWeight: FontWeight.bold),
                    ),
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
