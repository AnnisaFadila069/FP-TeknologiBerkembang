import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';


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

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // State nilai awal dropdown
  String selectedCategory = 'Fiction';
  String selectedStatus = 'Haven’t Read';
  String imagePath = '';
  bool isLoading = false;

  final List<String> availableImages = [
    'Image/bumi_manusia.jpg',
    'Image/gadis_pantai.jpg',
    'Image/mangir.jpg',
    'Image/anak_semua_bangsa.jpg',
    'Image/arus_balik.jpg',
    'Image/jejak_langkah.jpg',
    'Image/bumi_manusia_cover.jpg',
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
    'Haven’t Read',
    'Finished',
    'Reading',
  ];

  Future<void> _saveBook() async {
    // Validasi input
    if (_titleController.text.isEmpty ||
        _authorController.text.isEmpty ||
        _publisherController.text.isEmpty ||
        _descriptionController.text.isEmpty ||
        imagePath.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('All fields and an image are required')),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // Mendapatkan user ID yang sedang login
      final User? user = _auth.currentUser;
      if (user == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in')),
        );
        return;
      }

      // Menyimpan data ke Firestore
      await FirebaseFirestore.instance.collection('books').add({
        'title': _titleController.text,
        'author': _authorController.text,
        'publisher': _publisherController.text,
        'description': _descriptionController.text,
        'categories': selectedCategory,
        'status': selectedStatus,
        'created_at': FieldValue.serverTimestamp(),
        'user_id': user.uid, // Tautkan ke user_id
        'imagePath': imagePath, // Tambahkan path gambar
      });

      // Menampilkan pesan berhasil
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Book added successfully!')),
      );

      // Pindah ke halaman Home
      Navigator.pushReplacement( context,
      MaterialPageRoute(builder: (context) => const MainPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
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
    }
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
          'Add Book',
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
              child: CircularProgressIndicator(),
            ) // Loading indicator
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Gambar di tengah atas
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: GestureDetector(
                      onTap: _selectImage, // Panggil fungsi pemilihan gambar
                      child: Container(
                        width: 155,
                        height: 225,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE1DACA),
                          borderRadius: BorderRadius.circular(16),
                          image: imagePath.isNotEmpty
                              ? DecorationImage(
                                  image: AssetImage(imagePath),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: imagePath.isEmpty
                            ? const Icon(
                                Icons.add,
                                size: 40,
                                color: Color(0xFFB3907A),
                              )
                            : null,
                      ),
                    ),
                  ),

                  // Formulir input di bawah gambar
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                              backgroundColor: const Color(0xFFC1B6A3),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 32,
                                vertical: 12,
                              ),
                            ),
                            child: const Text(
                              'SAVE',
                              style: TextStyle(
                                fontFamily: 'BeVietnamPro',
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

// Custom Widgets
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
              color: Color(0xFF7B7B7D),
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            maxLines: maxLines,
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE1DACA),
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
              color: Color(0xFF7B7B7D),
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE1DACA),
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
                dropdownColor: const Color(0xFFF9F5EE),
              ),
            ),
          ),
        ],
      ),
    );
  }
}