import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
@override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() {
    // Tunggu selama 3 detik
    Timer(const Duration(seconds: 3), () {
      if (mounted) {
        // Gunakan context.go() untuk "teleport" ke halaman utama
        // Ini akan mereset tumpukan navigasi, sehingga pengguna
        // tidak bisa menekan "kembali" ke splash screen.
        context.goNamed('Login');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Ambil warna dari Config
    final config = Config();

    return Scaffold(
      // Gunakan warna latar belakang dari config
      backgroundColor: config.getAppTheme().scaffoldBackgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Tampilkan logo Anda dari assets
            Image.asset(
              'assets/images/app_logo.png', // Path yang Anda atur di pubspec.yaml
              width: 150, // Atur ukuran logo sesuai keinginan
              height: 150,
            ),
            const SizedBox(height: 24),
            Text(
              'Pharma Ease',
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(color: Config.primaryGreen),
            ),
            const SizedBox(height: 32),
            // Tampilkan loading spinner dengan warna primer
          ],
        ),
      ),
    );
  }
}