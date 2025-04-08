import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:omnitrics_thesis/tell_me_who_you_are/tell_me.dart';
import 'package:omnitrics_thesis/auth/sign-in/login.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({Key? key}) : super(key: key);

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  late Timer timer;

  @override
  void initState() {
    super.initState();
    // Send a verification email when the screen loads.
    FirebaseAuth.instance.currentUser?.sendEmailVerification();

    // Periodically check if the email is verified.
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser?.reload();
      if (FirebaseAuth.instance.currentUser!.emailVerified) {
        timer.cancel();
        // Redirect to the TellMe screen after verification.
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const TellMe()),
        );
      }
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Ensure ScreenUtil is initialized higher up in your app.
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple.shade700,
        title: const Text(
          "Email Verification",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        // Leading IconButton as provided.
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const LoginScreen()),
            );
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.deepPurple.shade700, Colors.deepPurple.shade400],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              child: Container(
                width: 340.w, 
                height: 590.h,// Responsive width using ScreenUtil.
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.r),
                  boxShadow: [
                    BoxShadow(
                      color:
                          const Color.fromARGB(255, 0, 0, 0).withOpacity(0.8),
                      spreadRadius: 4.r,
                      blurRadius: 16.r,
                      offset: Offset(0.w, 3.h),
                    ),
                  ],
                ),
                child: Container(
                  width: 300.w, // Responsive inner container width.
                  padding: EdgeInsets.symmetric(
                    horizontal: 24.w,
                    vertical: 32.h,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Title
                      Text(
                        'OmniTrics',
                        style: TextStyle(
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // Icon.
                      SizedBox(height: 10.h),
                      Icon(
                        Icons.email_outlined,
                        size: 150,
                        color: Colors.deepPurple,
                      ),
                      // Informational text.
                      SizedBox(height: 10.h),
                      Text(
                        'To ensure the security of your account and to activate all its features, '
                        'please check your email and take a moment to click on the following verification link,'
                        'which will confirm your email address and allow us to provide you with the full range of services we offer.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.5,
                          color: Color.fromARGB(255, 0, 0, 0)
                        ),
                      ),
                      SizedBox(height: 40.h),
                      Text(
                        'We have sent an email for verification.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14.sp,
                          height: 1.5.h,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 16.h),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            await FirebaseAuth.instance.currentUser
                                ?.sendEmailVerification();
                          },
                          style: ButtonStyle(
                            elevation:WidgetStateProperty.all(15.0),
                            shadowColor: WidgetStateProperty.all(
                              Colors.black.withOpacity(1.0),
                            ),
                            backgroundColor:
                                WidgetStateProperty.resolveWith<Color>(
                              (Set<WidgetState> states) {
                                if (states.contains(WidgetState.pressed)) {
                                  return Colors.deepPurple.shade900;
                                }
                                return Colors.deepPurple;
                              },
                            ),
                            foregroundColor: WidgetStateProperty.all<Color>(
                                Colors.white),
                            shape:
                                WidgetStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.r),
                              ),
                            ),
                            padding:
                                WidgetStateProperty.all<EdgeInsetsGeometry>(
                              EdgeInsets.symmetric(
                                horizontal: 90.w,
                                vertical: 15.h,
                              ),
                            ),
                          ),
                          child: const Text("Resend Email"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
