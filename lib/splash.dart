import 'package:flutter/material.dart';
import 'main.dart'; // Impor main.dart agar bisa langsung mengakses MainPage

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigasi ke MainPage setelah 3 detik
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const MainPage()), // Langsung ke MainPage
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5E1C8),
      body: Center(
        child: Image.asset(
          'Image/gambarLogo.png', // Ganti dengan path gambar Anda
          height: 200, // Sesuaikan ukuran gambar
        ),
      ),
    );
  }
}
