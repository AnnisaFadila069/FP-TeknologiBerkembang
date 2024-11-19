import 'package:flutter/material.dart';

class AddPageScreen extends StatelessWidget {
  const AddPageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.brown,
        title: const Text('Add New Book'),
      ),
      body: const Center(
        child: Text('Add Page Content Here'),
      ),
    );
  }
}