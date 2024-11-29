import 'package:flutter/material.dart';
import 'onboarding.dart'; // Impor WelcomeScreen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke WelcomeScreen setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WelcomeScreen()), // Navigasi ke WelcomeScreen
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1C8), // Cream background
      body: Center(
        child: Image.asset(
          'Image/BookMate.png', // Ganti dengan path gambar lokal Anda
          height: 200, // Sesuaikan ukuran gambar
        ),
      ),
    );
  }
}
