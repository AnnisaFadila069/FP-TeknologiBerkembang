import 'package:flutter/material.dart';
import 'detail_edit.dart'; // Sesuaikan dengan nama file Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Book Detail App',
      theme: ThemeData(
        primarySwatch: Colors.brown,
      ),
      home: const BookDetailPage(), // Menggunakan halaman BookDetailPage
    );
  }
}
