import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'custom_widgets.dart';
import 'package:intl/intl.dart';
import 'dart:convert'; // Untuk json.encode dan json.decode
import 'package:shared_preferences/shared_preferences.dart'; // Untuk SharedPreferences

class BookDetailPage extends StatefulWidget {
  final String bookId;

  const BookDetailPage({super.key, required this.bookId});

  @override
  _BookDetailPageState createState() => _BookDetailPageState();
}

class _BookDetailPageState extends State<BookDetailPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  // Image
  final List<String> availableImages = [
    'Image/bumi_manusia.jpg',
    'Image/gadis_pantai.jpg',
    'Image/mangir.jpg',
    'Image/anak_semua_bangsa.jpg',
    'Image/arus_balik.jpg',
    'Image/jejak_langkah.jpg',
    'Image/bumi_manusia_cover.jpg',
    'Image/logo_bookmate.png',
    'Image/filosofi_teras_cover.jpg',
    'Image/gadis_pantai_cover.jpg',
    'Image/hujan_cover.jpg',
    'Image/laskar_pelangi_cover.jpg',
    'Image/laut_bercerita_cover.jpg',
    'Image/mangir_cover.jpg',
    'Image/negara_5_menara_cover.jpg',
    'Image/rumah_kaca_cover.jpg',
    'Image/tentang_kamu_cover.jpg',
    'Image/tujuh_kelana_cover.jpg',
    'Image/sihir_perempuan_cover.jpg',
    'Image/cantik_itu_luka_cover.jpg',
    'Image/anak_semua_bangsa_cover.jpg',
    'Image/gadis_kretek_cover.jpg',
    'Image/sang_pemimpi_cover.jpg'
  ];

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
  DateTime? notesStartDate;
  DateTime? notesEndDate;
  late String shortNote;
  late String review;
  bool isFavorite = false; // Nilai default

  // Variabel sementara untuk notes
  DateTime? tempNotesStartDate;
  DateTime? tempNotesEndDate;
  late String tempShortNote;
  late String tempReview;
  late bool tempIsFavorite = false;

  // Variabel untuk menyimpan data asli dari Firestore
  DateTime? initialNotesStartDate;
  DateTime? initialNotesEndDate;
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

    // Inisialisasi variabel sementara dengan nilai default
    tempTitle = '';
    tempAuthor = '';
    tempPublisher = '';
    tempDescription = '';
    tempCategory = 'Fiction';
    tempStatus = 'Haven’t Read';

    // Inisialisasi TextEditingController
    _titleController = TextEditingController(text: tempTitle);
    _authorController = TextEditingController(text: tempAuthor);
    _publisherController = TextEditingController(text: tempPublisher);
    _descriptionController = TextEditingController(text: tempDescription);

    // Inisialisasi notes
    notesStartDate = null;
    notesEndDate = null;
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

// Memuat cache
  void _cacheBookDetails(Map<String, dynamic> data) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('cachedBook_${widget.bookId}', json.encode(data));
      print("Book details cached successfully.");
    } catch (e) {
      print("Error caching book details: $e");
    }
  }

  Future<Map<String, dynamic>> _getCachedBookDetails() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString('cachedBook_${widget.bookId}');
      if (cachedData != null) {
        return json.decode(cachedData) as Map<String, dynamic>;
      }
    } catch (e) {
      print("Error retrieving cached book details: $e");
    }
    return {};
  }

  Future<void> _loadBookDetails() async {
    setState(() {
      isLoading = true; // Mulai loading
    });

    try {
      // Cek cache terlebih dahulu
      final cachedData = await _getCachedBookDetails();
      if (cachedData.isNotEmpty) {
        setState(() {
          _titleController.text = cachedData['title'];
          _authorController.text = cachedData['author'];
          _publisherController.text = cachedData['publisher'];
          _descriptionController.text = cachedData['description'];
          selectedCategory = cachedData['category'] ?? 'Fiction';
          selectedStatus = cachedData['status'] ?? 'Haven’t Read';
          imagePath = cachedData['imagePath'] ?? '';
        });
      }
      // Ambil data terbaru dari Firestore
      final bookData =
          await _firestore.collection('books').doc(widget.bookId).get();
      final data = bookData.data();
      if (data != null) {
        setState(() {
          // Data buku
          _titleController.text = data['title'] ?? '';
          _authorController.text = data['author'] ?? '';
          _publisherController.text = data['publisher'] ?? '';
          _descriptionController.text = data['description'] ?? '';
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
          initialTitle = tempTitle;
          initialAuthor = tempAuthor;
          initialPublisher = tempPublisher;
          initialDescription = tempDescription;
          initialCategory = tempCategory;
          initialStatus = tempStatus;

          // Data notes
          final notes = data['notes'] ?? {};
          notesStartDate = notes['notesStartDate'] != null
              ? (notes['notesStartDate'] as Timestamp).toDate()
              : null;

          notesEndDate = notes['notesEndDate'] != null
              ? (notes['notesEndDate'] as Timestamp).toDate()
              : null;
          shortNote = notes['shortNote'] ?? '';
          review = notes['review'] ?? '';
          isFavorite = notes['isFavorite'] ?? false;

          // Sinkronkan dengan controller
          notesStartDateController.text = notesStartDate != null
              ? DateFormat('dd-MM-yyyy').format(notesStartDate!)
              : '';

          notesEndDateController.text = notesEndDate != null
              ? DateFormat('dd-MM-yyyy').format(notesEndDate!)
              : '';

          shortNoteController.text = shortNote;
          reviewController.text = review;

          // Inisialisasi data notes sementara
          tempNotesStartDate = notesStartDate ?? DateTime.now();
          tempNotesEndDate = notesEndDate ?? DateTime.now();
          tempShortNote = shortNote;
          tempReview = review;
          tempIsFavorite = isFavorite;

          // Simpan data awal notes
          initialNotesStartDate = tempNotesStartDate;
          initialNotesEndDate = tempNotesEndDate;
          initialShortNote = tempShortNote;
          initialReview = tempReview;
          initialIsFavorite = tempIsFavorite;
        });
      }
    } catch (e) {
      // Tangani error jika ada
      print('Error loading book details: $e');
    } finally {
      setState(() {
        isLoading = false; // Selesai loading
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
                notesStartDateController.text = tempNotesStartDate != null
                    ? DateFormat('dd-MM-yyyy').format(tempNotesStartDate!)
                    : '';
                notesEndDateController.text = tempNotesEndDate != null
                    ? DateFormat('dd-MM-yyyy').format(tempNotesEndDate!)
                    : '';
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
      await _saveBook();
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
        'notesStartDate': tempNotesStartDate != null
            ? Timestamp.fromDate(tempNotesStartDate!)
            : null,
        'notesEndDate': tempNotesEndDate != null
            ? Timestamp.fromDate(tempNotesEndDate!)
            : null,
        'shortNote': tempShortNote,
        'review': tempReview,
        'isFavorite': tempIsFavorite,
      },
    });

    setState(() {
      // Perbarui data utama setelah menyimpan
      initialTitle = tempTitle;
      initialAuthor = tempAuthor;
      initialPublisher = tempPublisher;
      initialDescription = tempDescription;
      initialCategory = tempCategory;
      initialStatus = tempStatus;

      initialNotesStartDate = tempNotesStartDate;
      initialNotesEndDate = tempNotesEndDate;
      initialShortNote = tempShortNote;
      initialReview = tempReview;
      initialIsFavorite = tempIsFavorite;

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
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator()) // Loading indicator
          : SingleChildScrollView(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap:
                              _selectImage, // Panggil fungsi pemilihan gambar
                          child: Container(
                            width: 100,
                            height: 140,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE1DACA),
                              borderRadius: BorderRadius.circular(8),
                              image: imagePath.isNotEmpty
                                  ? DecorationImage(
                                      image: AssetImage(
                                          imagePath), // Gunakan AssetImage
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
                          child: _buildBookDetail(), // Menampilkan detail buku
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

  Widget _buildBookDetail() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          initialTitle,
          style: const TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF7B7B7D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Author: $initialAuthor',
          style: const TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF918674),
          ),
        ),
        Text(
          'Publisher: $initialPublisher',
          style: const TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF918674),
          ),
        ),
        Text(
          'Categories: $initialCategory',
          style: const TextStyle(
            fontFamily: 'BeVietnamPro',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF918674),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: initialStatus == 'Haven’t Read'
                ? Colors.red
                : initialStatus == 'Reading'
                    ? Colors.orange
                    : Colors.green,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            initialStatus,
            style: const TextStyle(
              fontFamily: 'BeVietnamPro',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _selectImage() async {
    final selectedImage = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select an Image'),
          content: SizedBox(
            width: double.maxFinite,
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3, // Jumlah kolom
                crossAxisSpacing: 8.0, // Jarak horizontal antar item
                mainAxisSpacing: 8.0, // Jarak vertikal antar item
                childAspectRatio: 3 / 4, // Rasio lebar:tinggi (atur di sini)
              ),
              itemCount: availableImages.length,
              itemBuilder: (context, index) {
                final imagePath = availableImages[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.pop(context, imagePath); // Kembalikan path gambar
                  },
                  child: ClipRRect(
                    borderRadius:
                        BorderRadius.circular(8.0), // Membuat sudut melengkung
                    child: Image.asset(
                      imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );

    if (selectedImage != null) {
      setState(() {
        imagePath = selectedImage;
      });

      // Simpan perubahan gambar ke Firestore
      await _firestore.collection('books').doc(widget.bookId).update({
        'imagePath': imagePath,
      });
    }
  }

  Widget buildNotesForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomTextField(
          label: 'Starting Reading on',
          hintText: 'Enter Start Date',
          controller: notesStartDateController,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: tempNotesStartDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                tempNotesStartDate = pickedDate;
                notesStartDateController.text =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
              });
            } else {
              setState(() {
                tempNotesStartDate = null;
                notesStartDateController
                    .clear(); // Kosongkan TextField jika null
              });
            }
          },
          readOnly:
              true, // Membuat TextField hanya dapat diisi melalui DatePicker
        ),
        CustomTextField(
          label: 'Finished Reading on',
          hintText: 'Enter End Date',
          controller: notesEndDateController,
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: tempNotesEndDate ?? DateTime.now(),
              firstDate: DateTime(2000),
              lastDate: DateTime(2100),
            );
            if (pickedDate != null) {
              setState(() {
                tempNotesEndDate = pickedDate;
                notesEndDateController.text =
                    DateFormat('dd-MM-yyyy').format(pickedDate);
              });
            } else {
              setState(() {
                tempNotesEndDate = null;
                notesEndDateController.clear(); // Kosongkan TextField jika null
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
          hintText: 'Enter the title', // Hint jika kosong
          controller: _titleController,
          onChanged: (value) {
            setState(() {
              tempTitle = value;
            });
          },
        ),
        CustomTextField(
          label: 'Author',
          hintText: 'Enter the author', // Hint jika kosong
          controller: _authorController,
          onChanged: (value) {
            setState(() {
              tempAuthor = value;
            });
          },
        ),
        CustomTextField(
          label: 'Publisher',
          hintText: 'Enter the publisher', // Hint jika kosong
          controller: _publisherController,
          onChanged: (value) {
            setState(() {
              tempPublisher = value;
            });
          },
        ),
        CustomDropdown(
          label: 'Categories',
          items: const [
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
          value: tempCategory,
          onChanged: (value) {
            setState(() {
              tempCategory = value!;
            });
          },
        ),
        CustomDropdown(
          label: 'Status',
          items: const ['Haven’t Read', 'Reading', 'Finished'],
          value: tempStatus,
          onChanged: (value) {
            setState(() {
              tempStatus = value!;
            });
          },
        ),
        CustomTextField(
          label: 'Description',
          hintText: 'Enter a description', // Hint jika kosong
          controller: _descriptionController,
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

  @override
  void dispose() {
    _titleController.dispose();
    _authorController.dispose();
    _publisherController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
