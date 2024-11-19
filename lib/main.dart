import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart'; // For Be Vietnam Pro font
import 'package:smooth_page_indicator/smooth_page_indicator.dart'; // For page indicator
import 'detailpagescreen.dart';
import 'homescreen.dart';

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
      ),
      home: const HomeScreen(),
    );
  }
}

