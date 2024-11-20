import 'package:flutter/material.dart';
import 'add_page.dart';
import 'detail_edit.dart'; // Sesuaikan dengan nama file Anda

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Pindahkan ke sini
      title: 'BookMate', // Pindahkan ke sini
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.brown),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5EB),
        elevation: 0,
        title: Row(
          children: [
            Image.asset(
              'Image/logo BookMate.png', // Sesuaikan dengan nama folder sebenarnya
              height: 42,
            ),
            const SizedBox(width: 8),
            const Text(
              'BookMate',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add, color: Color(0xFF918673)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AddPage()),
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Text(
          'Welcome to BookMate!',
          style: TextStyle(fontSize: 20, fontFamily: 'BeVietnamPro'),
        ),
      ),
    );
  }
}
