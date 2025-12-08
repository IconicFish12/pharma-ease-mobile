import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_course_fp/config/config.dart';

class SendEmailPage extends StatefulWidget {
  const SendEmailPage({super.key});

  @override
  State<SendEmailPage> createState() => _SendEmailPageState();
}

class _SendEmailPageState extends State<SendEmailPage> {
  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Ilustrasi Icon
              Container(
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Config.primaryGreen.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mark_email_read_outlined,
                  size: 80,
                  color: Config.primaryGreen,
                ),
              ),

              const SizedBox(height: 32),

              Text(
                "Check your mail",
                style: textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Config.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 16),

              Text(
                "We have sent password recovery instructions to your email.",
                textAlign: TextAlign.center,
                style: textTheme.bodyLarge?.copyWith(
                  color: Config.textSecondary,
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 48),

              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: () {
                    // Kembali ke halaman Login
                    // Menggunakan go('/login') untuk membersihkan stack
                    // Asumsi rute login adalah '/login'
                    context.goNamed('Login');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Config.primaryGreen,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Back to Login",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              TextButton(
                onPressed: () {
                  // Logika kirim ulang email
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Email sent again!")),
                  );
                },
                child: Text(
                  "Did not receive the email? Resend",
                  style: TextStyle(color: Config.primaryGreen),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}