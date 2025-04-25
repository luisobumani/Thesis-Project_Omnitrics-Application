import 'package:flutter/material.dart';
import 'dart:ui'; 
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/getStarted/Widget/get_started_button.dart'; 
import '../auth/sign-in/login.dart'; 
class Disclaimer extends StatefulWidget {
  const Disclaimer({Key? key}) : super(key: key);

  @override
  _DisclaimerState createState() => _DisclaimerState();
}

class _DisclaimerState extends State<Disclaimer> {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        _opacity = 1.0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        fit: StackFit.expand,
        children: [
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
            child: Container(
              color: Colors.black.withOpacity(0), // Required child for BackdropFilter.
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: EdgeInsets.all(40.w),
                  child: AnimatedOpacity(
                    opacity: _opacity,
                    duration: const Duration(milliseconds: 500),
                    child: Container(
                      constraints: BoxConstraints(maxWidth: 500.w),
                      padding: EdgeInsets.all(27.w),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Colors.deepPurple, Color.fromARGB(255, 176, 59, 211)],
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                        ),
                        borderRadius: BorderRadius.circular(10.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 8.r,
                            offset: Offset(0, 4.h),
                          ),
                        ],
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.warning_amber_rounded,
                              size: 100.sp,
                              color: const Color.fromARGB(255, 235, 17, 17),
                            ),
                            SizedBox(height: 16.h),
                            Text(
                              'DISCLAIMER',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 30.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 8.h),
                            Text(
                              '''This app is designed to aid individuals with color blindness by enhancing color perception. However, it's not a medical device and should not replace professional eye care. It does not cure or reverse color blindness. Results may vary based on individual vision and environmental factors. Consult an optometrist or ophthalmologist for diagnosis and treatment. Use this app as a supplementary tool to improve color differentiation, not as a definitive medical solution.''',
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                  const Spacer(),
                  getStartedButton(
                    onPressed: () {
                      showDialog(
                        context: context, 
                        builder: (BuildContext context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.r),
                            side: BorderSide(color: Colors.deepPurple, width: 1.w)
                          ),
                          insetPadding: EdgeInsets.all(20.0.h),
                          title: Text('Disclaimer',
                           style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold
                           ),),
                          content: Text('''This app is designed to aid individuals with color blindness by enhancing color perception. However, it's not a medical device and should not replace professional eye care. It does not cure or reverse color blindness. Results may vary based on individual vision and environmental factors. Consult an optometrist or ophthalmologist for diagnosis and treatment. Use this app as a supplementary tool to improve color differentiation, not as a definitive medical solution.''',
                          textAlign: TextAlign.justify,
                          style: TextStyle(
                            fontSize: 14.sp
                          ),),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                context,
                                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                                );
                              }, 
                              style: ButtonStyle(
                                foregroundColor: WidgetStateProperty.all<Color>(
                                  Colors.white
                                ),
                                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                                  (Set<WidgetState> states) {
                                    if (states.contains(WidgetState.pressed)) {
                                      return Colors.deepPurple.shade900;
                                    }
                                    return Colors.deepPurple;
                                  }
                                ),
                                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.r)))
                              ),
                              child: Text('I understand'))
                          ],
                          );
                        });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
