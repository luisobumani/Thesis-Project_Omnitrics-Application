import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';               
import 'package:omnitrics_thesis/auth/Services/auth_redirect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await availableCameras();

  runApp(
    ShowCaseWidget(
      // <-- pass a WidgetBuilder directly, not a Builder widget
      builder: (context) => const MyApp(),
    ),
  );
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
          home: AnimatedSplashScreen(
            splash: 'assets/gifs/omnitrics_logo_gif.gif',
            splashIconSize: 300.0,
            centered: true,
            nextScreen: AuthRedirect(),
            backgroundColor: Colors.deepPurple,
            duration: 3000,
          ),
          theme: ThemeData(fontFamily: 'Inter'),
        );
      },
    );
  }
}
