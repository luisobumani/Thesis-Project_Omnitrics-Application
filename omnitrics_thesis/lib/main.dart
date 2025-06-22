import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:firebase_core/firebase_core.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:showcaseview/showcaseview.dart';               
import 'package:omnitrics_thesis/auth/Services/auth_redirect.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization
  if (kIsWeb) {
    await Firebase.initializeApp(
      options: FirebaseOptions(
        apiKey: "AIzaSyAAVfoPNfVm5NZc2gqCZV7TFMbV5WN4wbQ",
        authDomain: "omnitrics-9f148.firebaseapp.com",
        databaseURL: "https://omnitrics-9f148-default-rtdb.firebaseio.com",
        projectId: "omnitrics-9f148",
        storageBucket: "omnitrics-9f148.firebasestorage.app",
        messagingSenderId: "1032258584893",
        appId: "1:1032258584893:web:267ccf9e2dcf5e5c564554",
        measurementId: "G-MSN9EKY5SY",
      ),
    );
  } else {
    await Firebase.initializeApp();
  }

  await availableCameras();

  runApp(
    ShowCaseWidget(
      builder: (context) => const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Web-specific configuration
    if (kIsWeb) {
      return LayoutBuilder(
        builder: (context, constraints) {
          // Initialize ScreenUtil with web-appropriate settings
          ScreenUtil.init(
            context,
            designSize: Size(constraints.maxWidth, constraints.maxHeight),
            minTextAdapt: true,
            splitScreenMode: true,
          );
          
          return MaterialApp(
            title: 'OmniTrics',
            debugShowCheckedModeBanner: false,
            home: AnimatedSplashScreen(
              splash: 'assets/gifs/omnitrics_logo_gif.gif',
              splashIconSize: 300.0, // Using responsive sizing
              centered: true,
              nextScreen: AuthRedirect(),
              backgroundColor: Colors.deepPurple,
              duration: 3000,
            ),
            theme: ThemeData(fontFamily: 'Inter'),
            builder: (context, child) {
              return MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  textScaleFactor: 1.0, // Force consistent text scaling
                ),
                child: child!,
              );
            },
          );
        },
      );
    }
    
    // Mobile configuration
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
            splashIconSize: 300.0, // Using responsive sizing
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