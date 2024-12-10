import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_widgets.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _publisherController;
  late TextEditingController _descriptionController;

  bool isEditing = false;
  String selectedCategory = 'Fiction';
  String selectedStatus = 'Haven’t Read';
  String imagePath = "";

  @override
  void initState() {
    super.initState();

    _titleController = TextEditingController();
    _authorController = TextEditingController();
    _publisherController = TextEditingController();
    _descriptionController = TextEditingController();

    _loadBookDetails();
  }

  Future<void> _loadBookDetails() async {
    final bookData = await _firestore.collection('books').doc(widget.bookId).get();
    final data = bookData.data();
    if (data != null) {
      setState(() {
        _titleController.text = data['title'];
        _authorController.text = data['author'];
        _publisherController.text = data['publisher'];
        _descriptionController.text = data['description'];
        selectedCategory = data['category'] ?? 'Fiction';
        selectedStatus = data['status'] ?? 'Haven’t Read';
        imagePath = data['imagePath'] ?? '';
      });
    }
  }

  Future<void> _saveBook() async {
    await _firestore.collection('books').doc(widget.bookId).update({
      'title': _titleController.text,
      'author': _authorController.text,
      'publisher': _publisherController.text,
      'description': _descriptionController.text,
      'category': selectedCategory,
      'status': selectedStatus,
      'imagePath': imagePath,
    });
    setState(() {
      isEditing = false;
    });
  }

  Future<void> _deleteBook() async {
    await _firestore.collection('books').doc(widget.bookId).delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5EB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5EB),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Detail Book',
          style: TextStyle(
            fontFamily: 'BeVietnamPro',
            color: Colors.black,
            fontSize: 23,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GestureDetector(
                    onTap: () async {
                      // Logika memilih gambar
                    },
                    child: Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1DACA),
                        borderRadius: BorderRadius.circular(8),
                        image: imagePath.isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(imagePath),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: imagePath.isEmpty
                          ? const Icon(Icons.add,
                              size: 40, color: Color(0xFFB3907A))
                          : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _titleController.text,
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Author: ${_authorController.text}',
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Publisher: ${_publisherController.text}',
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Categories: $selectedCategory',
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: selectedStatus == 'Haven’t Read'
                                ? Colors.red
                                : selectedStatus == 'Reading'
                                    ? Colors.orange
                                    : Colors.green,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            selectedStatus,
                            style: const TextStyle(
                              fontFamily: 'BeVietnamPro',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = false;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: !isEditing
                          ? const Color(0xFFC1B6A3)
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Notes',
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        isEditing = true;
                      });
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isEditing
                          ? const Color(0xFFC1B6A3)
                          : Colors.grey.shade300,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Edit',
                      style: TextStyle(
                        fontFamily: 'BeVietnamPro',
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              isEditing ? _buildEditForm() : buildNotesForm(),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildNotesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const CustomTextField(
            label: 'Starting Reading on', hintText: 'dd-mm-yyyy'),
        const CustomTextField(
            label: 'Finished Reading on', hintText: 'dd-mm-yyyy'),
        const CustomTextField(
            label: 'Short Note', hintText: 'Enter Notes', maxLines: 3),
        const CustomTextField(
            label: 'Review', hintText: 'Enter Review', maxLines: 3),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add to Favorite Book',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 14,
                color: Colors.black,
              ),
            ),
            Switch(value: false, onChanged: (val) {}),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              // Simpan data
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFC1B6A3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
            ),
            child: const Text(
              'SAVE',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildEditForm() {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      CustomTextField(
        label: 'Title',
        hintText: _titleController.text,
        controller: _titleController,
      ),
      CustomTextField(
        label: 'Author',
        hintText: _authorController.text,
        controller: _authorController,
      ),
      CustomTextField(
        label: 'Publisher',
        hintText: _publisherController.text,
        controller: _publisherController,
      ),
      CustomDropdown(
        label: 'Categories',
        items: ['Fiction',
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
                'Graphic Novels & Comics',],
        value: ['Fiction',
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
                'Graphic Novels & Comics',].contains(selectedCategory)
            ? selectedCategory
            : 'Fiction', // Fallback jika value tidak valid
        onChanged: (value) {
          setState(() {
            selectedCategory = value!;
          });
        },
      ),
      CustomDropdown(
        label: 'Status',
        items: ['Haven’t Read', 'Reading', 'Finished'],
        value: ['Haven’t Read', 'Reading', 'Finished'].contains(selectedStatus)
            ? selectedStatus
            : 'Haven’t Read', // Fallback jika value tidak valid
        onChanged: (value) {
          setState(() {
            selectedStatus = value!;
          });
        },
      ),
      CustomTextField(
        label: 'Description',
        hintText: _descriptionController.text,
        controller: _descriptionController,
        maxLines: 4,
      ),
      const SizedBox(height: 16),
      Center(
        child: ElevatedButton(
          onPressed: _saveBook,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFC1B6A3),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          ),
          child: const Text(
            'SAVE',
            style: TextStyle(
              fontFamily: 'BeVietnamPro',
              color: Colors.white,
              fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }
}