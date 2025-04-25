import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:omnitrics_thesis/auth/Services/auth_redirect.dart';


void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp();

  await availableCameras();

  // Run the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 915),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
            title: 'OmniTrics',
            debugShowCheckedModeBanner: false,
            // Animated splash screen
            home: AnimatedSplashScreen(
              splash: 'assets/gifs/omnitrics_logo_gif.gif',
              splashIconSize: 300.0,
              centered: true,
              nextScreen: AuthRedirect(), // Navigate to Home after the splash
              backgroundColor: Colors.deepPurple,
              duration: 3000,
            ),
            theme: ThemeData(
              fontFamily: 'Inter',
            ));
      },
    );
  }
}
