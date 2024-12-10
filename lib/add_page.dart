import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AddPage extends StatefulWidget {
  const AddPage({super.key});

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  // Controllers untuk TextField
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _authorController = TextEditingController();
  final TextEditingController _publisherController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  // State nilai awal dropdown
  String selectedCategory = 'Fiction';
  String selectedStatus = 'Not Started';

  final List<String> _categories = [
    'Fiction',
    'Non-Fiction',
    'Self-Help & Personal Development',
    'Business & Finance',
    'Science & Technology',
    'Health & Wellness',
    'Biography & Memoir',
    'History',
    'Religion & Spirituality',
    'Education & Reference',
    'Art & Design',
    'Travel & Adventure',
    'Poetry',
    'Children’s Books',
    'Graphic Novels & Comics',
  ];

  final List<String> _statuses = [
    'Not Started',
    'Completed',
    'Currently Reading',
  ];

  Future<void> _saveBook() async {
    // Validasi input
    if (_titleController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _publisherController.text.isEmpty ||
        _descriptionController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields are required')),
      );
      return;
    }

    try {
      // Menyimpan data ke Firestore
      await FirebaseFirestore.instance.collection('books').add({
        'title': _titleController.text,
        'author': _authorController.text,
        'publisher': _publisherController.text,
        'description': _descriptionController.text,
        'categories': selectedCategory,
        'status': selectedStatus,
        'created_at': FieldValue.serverTimestamp(),
      });

      // Menampilkan pesan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully!')),
      );

      // Kembali ke halaman sebelumnya
      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EE), // Pale pink
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5EE), // Pale pink
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Add Book',
          style: TextStyle(
            fontFamily: 'BeVietnamPro',
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: GestureDetector(
                  onTap: () {
                    // Fungsi upload image jika diperlukan
                  },
                  child: Container(
                    width: 100,
                    height: 140,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE1DACA), // Box color
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.add, size: 40, color: Color(0xFF7B7B7D)),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              CustomTextField(
                label: 'Title',
                hintText: 'Enter Title',
                controller: _titleController,
              ),
              CustomTextField(
                label: 'Author',
                hintText: 'Enter Author',
                controller: _authorController,
              ),
              CustomTextField(
                label: 'Publisher',
                hintText: 'Enter Publisher',
                controller: _publisherController,
              ),
              CustomDropdown(
                label: 'Categories',
                items: _categories,
                value: selectedCategory,
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value!;
                  });
                },
              ),
              CustomDropdown(
                label: 'Status',
                items: _statuses,
                value: selectedStatus,
                onChanged: (value) {
                  setState(() {
                    selectedStatus = value!;
                  });
                },
              ),
              CustomTextField(
                label: 'Description',
                hintText: 'Enter Description',
                controller: _descriptionController,
                maxLines: 5,
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton(
                  onPressed: _saveBook,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFC1B6A3), // Save button color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  ),
                  child: const Text(
                    'SAVE',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      color: Colors.white, // Save text color
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final int maxLines;

  const CustomTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7B7B7D), // Label color
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE1DACA), // Box color
              hintText: hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String value;
  final ValueChanged<String?>? onChanged;

  const CustomDropdown({
    super.key,
    required this.label,
    required this.items,
    required this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF7B7B7D), // Label color
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE1DACA), // Box color
              borderRadius: BorderRadius.circular(8),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: value,
                items: items.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: const TextStyle(
                        fontFamily: 'BeVietnamPro',
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                dropdownColor: const Color(0xFFF9F5EE), // Dropdown background
              ),
            ),
          ),
        ],
      ),
    );
  }
}
