import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Be Vietnam Pro font
import 'homescreen.dart';
import 'history.dart';
import 'forgotpasswordpage.dart'; // Mengimpor ForgotPasswordPage
import 'loginpage.dart'; // Mengimpor LoginPage

void main() {
  runApp(const BookMateApp());
}

class BookMateApp extends StatelessWidget {
  const BookMateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: GoogleFonts.beVietnamProTextTheme(), // Applying Be Vietnam Pro
        primaryColor: Colors.brown,
      ),
      home: LoginPage(), // Ganti home ke halaman login terlebih dahulu
    );
  }
}