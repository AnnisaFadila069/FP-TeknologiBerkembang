import 'package:flutter/material.dart';

class DetailPageScreen extends StatelessWidget {
  final String bookTitle;

  const DetailPageScreen({super.key, required this.bookTitle});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: Text(bookTitle),
      ),
      body: Center(
        child: Text(
          'Detail informasi untuk buku: $bookTitle',
          style: const TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
