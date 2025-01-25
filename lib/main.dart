import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'pages/main_screens/profile_page.dart';
import 'pages/main_screens/speech_recording.dart';
import 'pages/main_screens/training_page.dart';
import 'pages/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: MediaQuery.of(context).size,
      minTextAdapt: true,
      builder: (context, child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(primarySwatch: Colors.blue),
          home: const SplashScreen(),
          routes: {
      '/SpeechRecording': (context) => SpeechRecording(),
      '/TrainingPage': (context) => TrainingPage(),
      '/ProfilePage': (context) => ProfilePage(),
    },
        );
      },
    );
  }
}

