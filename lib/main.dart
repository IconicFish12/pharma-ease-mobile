import 'package:flutter/material.dart';
import 'package:mobile_course_fp/views/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PharmaEase',
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
