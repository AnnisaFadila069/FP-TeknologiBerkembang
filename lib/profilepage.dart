import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  @override
  void initState() {
    super.initState();
    fullNameController.text = widget.username; // Isi dengan username
  }

  Future<void> _saveProfile() async {
    try {
      final uid = FirebaseAuth.instance.currentUser?.uid;

      if (uid != null) {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'fullName': fullNameController.text.trim(),
          'phoneNumber': phoneNumberController.text.trim(),
          'dateOfBirth': dateOfBirthController.text.trim(),
          'gender': selectedGender,
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
    body: Padding(
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
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Foto Profil
          Center(
            child: Stack(
              children: [
                const CircleAvatar(
                  radius: 70,
                  backgroundColor: Color(0xFFB3907A), // Warna bingkai
                  child: CircleAvatar(
                    radius: 66,
                    backgroundImage: AssetImage('Image/profile.jpg'), // Ganti dengan URL gambar Anda
                  ),
                ),
                Positioned(
                  bottom: 0,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      // Logic for editing profile picture
                    },
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
            const SizedBox(height: 20),
            // Form input sesuai UI Anda
            _buildLabeledFormField('Full Name', fullNameController),
            const SizedBox(height: 15),
            _buildLabeledFormField('Phone Number', phoneNumberController,
                keyboardType: TextInputType.phone),
            const SizedBox(height: 15),
            _buildDateOfBirthField(),
            const SizedBox(height: 15),
            _buildGenderDropdown(),
            const Spacer(),
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
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 50),
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
    );
  }

  Widget _buildLabeledFormField(String label, TextEditingController controller,
      {TextInputType keyboardType = TextInputType.text}) {
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
          keyboardType: keyboardType,
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
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: IconButton(
            icon: const Icon(Icons.calendar_today, color: Color(0xFFB3907A)), // Warna ikon
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
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFB3907A)), // Warna ikon
        ),
        const Divider(color: Color(0xFFB3907A)), // Garis pembatas
      ],
    );
  }
}