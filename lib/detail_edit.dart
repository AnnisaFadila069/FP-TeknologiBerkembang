import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_widgets.dart';
import 'package:intl/intl.dart';

class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({Key? key, required this.bookId}) : super(key: key);

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //variabel sementara
  late String tempTitle;
  late String tempAuthor;
  late String tempPublisher;
  late String tempDescription;
  late String tempCategory;
  late String tempStatus;

  late TextEditingController _titleController;
  late TextEditingController _authorController;
  late TextEditingController _publisherController;
  late TextEditingController _descriptionController;

  late String initialTitle;
  late String initialAuthor;
  late String initialPublisher;
  late String initialDescription;
  late String initialCategory;
  late String initialStatus;

  // Variabel untuk menyimpan notes
  late DateTime notesStartDate;
  late DateTime notesEndDate;
  late String shortNote;
  late String review;
  bool isFavorite = false; // Nilai default

// Variabel sementara untuk notes
  late DateTime tempNotesStartDate;
  late DateTime tempNotesEndDate;
  late String tempShortNote;
  late String tempReview;
  late bool tempIsFavorite = false;

  // Variabel untuk menyimpan data asli dari Firestore
  late DateTime initialNotesStartDate;
  late DateTime initialNotesEndDate;
  late String initialShortNote;
  late String initialReview;
  late bool initialIsFavorite = false;

// Controller untuk input
  late TextEditingController shortNoteController;
  late TextEditingController reviewController;

// Controller untuk format tanggal (opsional jika menggunakan DatePicker)
  late TextEditingController notesStartDateController;
  late TextEditingController notesEndDateController;

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

    // Inisialisasi notes
    notesStartDate = DateTime.now();
    notesEndDate = DateTime.now();
    shortNote = '';
    review = '';
    isFavorite = false;

    // Inisialisasi controller
    shortNoteController = TextEditingController();
    reviewController = TextEditingController();
    notesStartDateController = TextEditingController();
    notesEndDateController = TextEditingController();

    _loadBookDetails();
  }

  Future<void> _loadBookDetails() async {
    final bookData =
        await _firestore.collection('books').doc(widget.bookId).get();
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

        // Inisialisasi variabel sementara
        tempTitle = _titleController.text;
        tempAuthor = _authorController.text;
        tempPublisher = _publisherController.text;
        tempDescription = _descriptionController.text;
        tempCategory = selectedCategory;
        tempStatus = selectedStatus;

        // Simpan data awal
        initialTitle = _titleController.text;
        initialAuthor = _authorController.text;
        initialPublisher = _publisherController.text;
        initialDescription = _descriptionController.text;
        initialCategory = selectedCategory;
        initialStatus = selectedStatus;

        // Muat data notes
        notesStartDate =
            (data['notes']['notesStartDate'] as Timestamp?)?.toDate() ??
                DateTime.now();
        notesEndDate =
            (data['notes']['notesEndDate'] as Timestamp?)?.toDate() ??
                DateTime.now();
        shortNote = data['notes']['shortNote'] ?? '';
        review = data['notes']['review'] ?? '';
        isFavorite = data['notes']['isFavorite'] ?? false;

        // Sinkronkan dengan controller
        notesStartDateController.text =
            DateFormat('dd-MM-yyyy').format(notesStartDate);
        notesEndDateController.text =
            DateFormat('dd-MM-yyyy').format(notesEndDate);
        shortNoteController.text = shortNote;
        reviewController.text = review;

        // Data notes
        if (data['notes'] != null) {
          notesStartDate =
              (data['notes']['notesStartDate'] as Timestamp).toDate();
          notesEndDate = (data['notes']['notesEndDate'] as Timestamp).toDate();
          shortNote = data['notes']['shortNote'] ?? '';
          review = data['notes']['review'] ?? '';
          isFavorite = data['notes']['isFavorite'] ?? false;

          // Data buku
          tempTitle = data['title'] ?? '';
          tempAuthor = data['author'] ?? '';
          tempPublisher = data['publisher'] ?? '';
          tempDescription = data['description'] ?? '';
          tempCategory = data['category'] ?? 'Fiction';
          tempStatus = data['status'] ?? 'Haven’t Read';

          // Data notes
          tempNotesStartDate =
              (data['notes']['notesStartDate'] as Timestamp?)?.toDate() ??
                  DateTime.now();
          tempNotesEndDate =
              (data['notes']['notesEndDate'] as Timestamp?)?.toDate() ??
                  DateTime.now();
          tempShortNote = data['notes']['shortNote'] ?? '';
          tempReview = data['notes']['review'] ?? '';
          tempIsFavorite = data['notes']['isFavorite'] ?? false;

          // Simpan data awal
          initialNotesStartDate = tempNotesStartDate;
          initialNotesEndDate = tempNotesEndDate;
          initialShortNote = tempShortNote;
          initialReview = tempReview;
          initialIsFavorite = tempIsFavorite;
        }
      });
    }
  }

  Future<void> _confirmAndSaveBook() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Changes'),
        content: const Text('Are you sure you want to save the changes?'),
        actions: [
          TextButton(
            onPressed: () {
              // Rollback semua data ke awal
              setState(() {
                tempTitle = initialTitle;
                tempAuthor = initialAuthor;
                tempPublisher = initialPublisher;
                tempDescription = initialDescription;
                tempCategory = initialCategory;
                tempStatus = initialStatus;

                // Rollback notes
                tempNotesStartDate = initialNotesStartDate;
                tempNotesEndDate = initialNotesEndDate;
                tempShortNote = initialShortNote;
                tempReview = initialReview;
                tempIsFavorite = initialIsFavorite;

                // Perbarui controller untuk memastikan tampilan sinkron
                notesStartDateController.text =
                    DateFormat('dd-MM-yyyy').format(tempNotesStartDate);
                notesEndDateController.text =
                    DateFormat('dd-MM-yyyy').format(tempNotesEndDate);
                shortNoteController.text = tempShortNote;
                reviewController.text = tempReview;
              });
              Navigator.pop(context, false); // Tutup dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Yes'),
          ),
        ],
      ),
    );

    if (confirm == true) {
      _saveBook();
    }
  }

  Future<void> _saveBook() async {
    await _firestore.collection('books').doc(widget.bookId).update({
      'title': tempTitle,
      'author': tempAuthor,
      'publisher': tempPublisher,
      'description': tempDescription,
      'category': tempCategory,
      'status': tempStatus,
      'imagePath': imagePath,
      'notes': {
        'notesStartDate': Timestamp.fromDate(tempNotesStartDate),
        'notesEndDate': Timestamp.fromDate(tempNotesEndDate),
        'shortNote': tempShortNote,
        'review': tempReview,
        'isFavorite': tempIsFavorite,
      },
    });

    setState(() {
      // Perbarui data utama setelah menyimpan
      _titleController.text = tempTitle;
      _authorController.text = tempAuthor;
      _publisherController.text = tempPublisher;
      _descriptionController.text = tempDescription;
      selectedCategory = tempCategory;
      selectedStatus = tempStatus;
      notesStartDate = tempNotesStartDate;
      notesEndDate = tempNotesEndDate;
      shortNote = tempShortNote;
      review = tempReview;
      isFavorite = tempIsFavorite;

      isEditing = false; // Keluar dari mode editing
    });
  }

  Future<void> _deleteBook() async {
    await _firestore.collection('books').doc(widget.bookId).delete();
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F5EE),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF9F5EE),
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
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF7B7B7D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Author: ${_authorController.text}',
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF918674),
                          ),
                        ),
                        Text(
                          'Publisher: ${_publisherController.text}',
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF918674),
                          ),
                        ),
                        Text(
                          'Categories: $selectedCategory',
                          style: const TextStyle(
                            fontFamily: 'BeVietnamPro',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF918674),
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
                              fontWeight: FontWeight.w400,
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
        CustomTextField(
          label: 'Starting Reading on',
          hintText: 'dd-mm-yyyy',
          controller: notesStartDateController,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: tempNotesStartDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                tempNotesStartDate = pickedDate; // Perbarui nilai sementara
                notesStartDateController.text = DateFormat('dd-MM-yyyy')
                    .format(pickedDate); // Sinkron controller
              });
            }
          },
          readOnly:
              true, // Membuat TextField hanya dapat diisi melalui DatePicker
        ),
        CustomTextField(
          label: 'Finished Reading on',
          hintText: 'dd-mm-yyyy',
          controller: notesEndDateController,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: tempNotesEndDate,
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                tempNotesEndDate = pickedDate; // Perbarui nilai sementara
                notesEndDateController.text = DateFormat('dd-MM-yyyy')
                    .format(pickedDate); // Sinkron controller
              });
            }
          },
          readOnly: true,
        ),
        CustomTextField(
          label: 'Short Note',
          hintText: 'Enter Notes',
          controller: shortNoteController,
          maxLines: 3,
          onChanged: (value) {
            setState(() {
              tempShortNote = value; // Simpan di variabel sementara
            });
          },
        ),
        CustomTextField(
          label: 'Review',
          hintText: 'Enter Review',
          controller: reviewController,
          maxLines: 3,
          onChanged: (value) {
            setState(() {
              tempReview = value; // Simpan di variabel sementara
            });
          },
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Add to Favorite Book',
              style: TextStyle(
                fontFamily: 'BeVietnamPro',
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color(0xFF7B7B7D),
              ),
            ),
            Switch(
              value: tempIsFavorite,
              onChanged: (val) async {
                setState(() {
                  tempIsFavorite = val; // Simpan status sementara
                });

                // Perbarui Firestore jika diperlukan
                await _firestore.collection('books').doc(widget.bookId).update({
                  'notes.isFavorite': tempIsFavorite,
                });
              },
              activeColor: const Color(0xFF918674), // Warna saat aktif (ON)
              inactiveThumbColor:
                  Colors.grey, // Warna tombol saat tidak aktif (opsional)
              inactiveTrackColor: Colors
                  .grey.shade300, // Warna lintasan saat tidak aktif (opsional)
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: ElevatedButton(
            onPressed: () {
              _confirmAndSaveBook(); // Gunakan fungsi konfirmasi
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
          hintText: tempTitle,
          controller: TextEditingController(text: tempTitle),
          onChanged: (value) {
            setState(() {
              tempTitle = value;
            });
          },
        ),
        CustomTextField(
          label: 'Author',
          hintText: tempAuthor,
          controller: TextEditingController(text: tempAuthor),
          onChanged: (value) {
            setState(() {
              tempAuthor = value;
            });
          },
        ),
        CustomTextField(
          label: 'Publisher',
          hintText: tempPublisher,
          controller: TextEditingController(text: tempPublisher),
          onChanged: (value) {
            setState(() {
              tempPublisher = value;
            });
          },
        ),
        CustomDropdown(
          label: 'Categories',
          items: [
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
          ],
          value: [
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
          ].contains(tempCategory) // Periksa apakah nilai ada dalam daftar
              ? tempCategory
              : 'Fiction', // Fallback jika nilai tidak valid
          onChanged: (value) {
            setState(() {
              tempCategory = value!;
            });
          },
        ),
        CustomDropdown(
          label: 'Status',
          items: ['Haven’t Read', 'Reading', 'Finished'],
          value: tempStatus,
          onChanged: (value) {
            setState(() {
              tempStatus = value!;
            });
          },
        ),
        CustomTextField(
          label: 'Description',
          hintText: tempDescription,
          controller: TextEditingController(text: tempDescription),
          maxLines: 4,
          onChanged: (value) {
            setState(() {
              tempDescription = value;
            });
          },
        ),
        const SizedBox(height: 16),
        Center(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Confirm Deletion'),
                      content: const Text(
                          'Are you sure you want to delete this book?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Delete'),
                        ),
                      ],
                    ),
                  );

                  if (confirm == true) {
                    await _deleteBook();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
              const SizedBox(width: 16), // Spasi antara tombol
              ElevatedButton(
                onPressed:
                    _confirmAndSaveBook, // Memanggil logika konfirmasi simpan
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC1B6A3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
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
        ),
      ],
    );
  }
}
