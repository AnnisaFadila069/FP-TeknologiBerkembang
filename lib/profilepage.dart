import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:fp_kelompok3/loginpage.dart';

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;

  const ProfilePage({super.key, required this.username, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();

  String selectedGender = 'Male';
  String imagePath = '';

  final List<String> availableImages = [
    'Image/avatar1.jpg',
    'Image/avatar2.jpg',
    'Image/avatar3.jpg',
    'Image/avatar4.jpg',
    'Image/avatar5.jpg',
    'Image/avatar6.jpg'
  ];

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.username;
    _loadProfileData();
  }

  Future<void> _loadProfileData() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid != null) {
      final snapshot =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      final data = snapshot.data();
      if (data != null) {
        setState(() {
          imagePath = data['imagePath'] ?? '';
          phoneNumberController.text = data['phoneNumber'] ?? '';
          dateOfBirthController.text = data['dateOfBirth'] ?? '';
          selectedGender = data['gender'] ?? 'Male';
        });
      }
    }
  }

  Future<void> _saveProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      // Validasi nomor telepon
      final phoneNumber = phoneNumberController.text.trim();
      if (!RegExp(r'^\d+$').hasMatch(phoneNumber)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('Phone number must contain only numbers.')),
        );
        return; // Hentikan proses jika validasi gagal
      }

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'fullName': fullNameController.text.trim(),
          'phoneNumber': phoneNumber,
          'dateOfBirth': dateOfBirthController.text.trim(),
          'gender': selectedGender,
          'imagePath': imagePath, // Menyimpan path gambar
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Profile saved successfully!')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save profile: $e')),
      );
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
            child: ListView.builder(
              itemCount: availableImages.length,
              itemBuilder: (context, index) {
                final imagePath = availableImages[index];
                return ListTile(
                  leading: Image.asset(imagePath, width: 50, height: 50),
                  title: Text('Image ${index + 1}'),
                  onTap: () {
                    Navigator.pop(context, imagePath); // Kembalikan path gambar
                  },
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
  void dispose() {
    fullNameController.dispose();
    phoneNumberController.dispose();
    dateOfBirthController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5EB),
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        // Tambahkan ini
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bagian atas: Tombol back dan Profile
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.black),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'Profile',
                    style: TextStyle(
                      fontFamily: 'BeVietnamPro',
                      color: Colors.black,
                      fontSize: 23,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Foto Profil
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 70,
                      backgroundColor: const Color(0xFFB3907A),
                      child: CircleAvatar(
                        radius: 66,
                        backgroundImage: imagePath.isEmpty
                            ? const AssetImage('Image/profile.jpg')
                            : AssetImage(imagePath),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 4,
                      child: GestureDetector(
                        onTap: _selectImage,
                        child: Container(
                          padding: const EdgeInsets.all(10),
                          decoration: const BoxDecoration(
                            color: Color(0xFFB3907A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.edit,
                            color: Color(0xFFF5F5EB),
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 15),
              // Pastikan konten lain cukup ruang dengan scroll
              _buildLabeledFormField('Full Name', fullNameController),
              _buildLabeledFormField('Phone Number', phoneNumberController,
                  isNumeric: true),
              _buildDateOfBirthField(),
              _buildGenderDropdown(),
              const SizedBox(height: 20),
              // Tombol Save
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _saveProfile();
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => LoginPage()),
                      (Route<dynamic> route) => false,
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB3907A),
                    padding: const EdgeInsets.symmetric(
                        vertical: 16, horizontal: 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                      side: const BorderSide(color: Colors.black),
                    ),
                  ),
                  child: Text(
                    'Save',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabeledFormField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text,
      bool isNumeric = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB3907A),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: isNumeric ? TextInputType.phone : keyboardType,
          inputFormatters:
              isNumeric ? [FilteringTextInputFormatter.digitsOnly] : [],
          onChanged: (value) {
            if (isNumeric && !RegExp(r'^\d*$').hasMatch(value)) {
              controller.text = value.replaceAll(RegExp(r'\D'), '');
              controller.selection = TextSelection.fromPosition(
                TextPosition(offset: controller.text.length),
              );
            }
          },
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFF5F5EB),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        const Divider(color: Color(0xFFB3907A)),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Date of Birth',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB3907A),
          ),
        ),
        TextField(
          controller: dateOfBirthController,
          readOnly: true,
          decoration: InputDecoration(
            filled: true,
            fillColor: const Color(0xFFF5F5EB), // Warna yang sama
            border: InputBorder.none,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: IconButton(
              icon: const Icon(Icons.calendar_today,
                  color: Color(0xFFB3907A)), // Warna ikon
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime.now(),
                );
                if (pickedDate != null) {
                  setState(() {
                    dateOfBirthController.text =
                        "${pickedDate.toLocal()}".split(' ')[0];
                  });
                }
              },
            ),
          ),
        ),
        const Divider(color: Color(0xFFB3907A)), // Garis pembatas
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB3907A),
          ),
        ),
        DropdownButtonFormField<String>(
          value: selectedGender,
          items: ['Male', 'Female'].map((gender) {
            return DropdownMenuItem(value: gender, child: Text(gender));
          }).toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) selectedGender = value;
            });
          },
          decoration: const InputDecoration(
            filled: true,
            fillColor: Color(0xFFF5F5EB), // Warna yang sama
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          dropdownColor: const Color(0xFFF5F5EB), // Warna dropdown
          style: const TextStyle(
            color: Colors.brown, // Warna teks dropdown
            fontSize: 14,
          ),
          icon: const Icon(Icons.arrow_drop_down,
              color: Color(0xFFB3907A)), // Warna ikon
        ),
        const Divider(color: Color(0xFFB3907A)), // Garis pembatas
      ],
    );
  }
}
