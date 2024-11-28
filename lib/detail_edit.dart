import 'package:flutter/material.dart';
import 'custom_widgets.dart';

class BookDetailPage extends StatefulWidget {
  final String bookTitle;
  final String bookImagePath;

  const BookDetailPage({super.key, required this.bookTitle, required this.bookImagePath});

  @override
  State<BookDetailPage> createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  String selectedCategory = 'Fiction';
  String selectedStatus = 'Haven’t Read';
  bool isEditing = false;
  late String imagePath;

  late TextEditingController titleController;
  final TextEditingController authorController =
      TextEditingController(text: "Nama Author");
  final TextEditingController publisherController =
      TextEditingController(text: "xxxxxxx");
  final TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.bookTitle);
    imagePath = widget.bookImagePath;
  }

  @override
  void dispose() {
    titleController.dispose();
    authorController.dispose();
    publisherController.dispose();
    descriptionController.dispose();
    super.dispose();
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
                      // Fungsi untuk memilih gambar
                    },
                    child: Container(
                      width: 100,
                      height: 140,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE1DACA),
                        borderRadius: BorderRadius.circular(8),
                        image: imagePath.isNotEmpty
                            ? DecorationImage(
                                image: AssetImage(imagePath),
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
                          titleController.text,
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Author: ${authorController.text}',
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Colors.black,
                          ),
                        ),
                        Text(
                          'Publisher: ${publisherController.text}',
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
              isEditing ? buildEditForm() : buildNotesForm(),
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

  Widget buildEditForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(label: 'Title', hintText: titleController.text),
        CustomTextField(label: 'Author', hintText: authorController.text),
        CustomTextField(label: 'Publisher', hintText: publisherController.text),
        CustomDropdown(
          label: 'Categories',
          items: ['Fiction', 'Non-Fiction', 'Sci-Fi'],
          value: selectedCategory,
          onChanged: (value) {
            setState(() {
              selectedCategory = value!;
            });
          },
        ),
        CustomDropdown(
          label: 'Status',
          items: ['Haven’t Read', 'Reading', 'Finished'],
          value: selectedStatus,
          onChanged: (value) {
            setState(() {
              selectedStatus = value!;
            });
          },
        ),
        CustomTextField(
            label: 'Description',
            hintText: descriptionController.text,
            maxLines: 5),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            ElevatedButton(
              onPressed: () {
                // Hapus buku
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey.shade300,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'DELETE',
                style: TextStyle(
                  fontFamily: 'BeVietnamPro',
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                // Save perubahan
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFC1B6A3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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
          ],
        ),
      ],
    );
  }
}