import 'package:flutter/material.dart';
import 'main.dart';
import 'loginpage.dart'; // Pastikan LoginPage diimpor

class ProfilePage extends StatefulWidget {
  final String username;
  final String email;

  ProfilePage({required this.username, required this.email});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController phoneNumberController = TextEditingController();
  final TextEditingController dateOfBirthController = TextEditingController();
  String selectedGender = 'Male';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F5EB),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Bagian Atas: Tombol Back dan Profile
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 10),
                Text(
                  'Profile',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),

            // Garis pembatas atas
            Divider(
              color: Color(0xFFC1B6A3),
            ),

            SizedBox(height: 20),

            // Foto Profil dan Tombol Edit
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 70,
                    backgroundColor: Color(0xFFB3907A),
                    child: CircleAvatar(
                      radius: 66,
                      backgroundImage: AssetImage('Image/profile.jpg'),
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
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFB3907A),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
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

            SizedBox(height: 20),

            // Full Name Field
            _buildLabeledFormField('Full Name', fullNameController),
            TextField(controller: fullNameController,),
            SizedBox(height: 15),

            // Phone Number Field
            _buildLabeledFormField('Phone Number', phoneNumberController,
                keyboardType: TextInputType.phone),
            SizedBox(height: 15),

            // Date of Birth Field
            _buildDateOfBirthField(),
            TextField(controller: dateOfBirthController,),
            SizedBox(height: 15),

            // Gender Dropdown
            _buildGenderDropdown(),

            // Spacer untuk menggeser tombol save ke bawah
            Spacer(),

            // Tombol Save
            Center(
              child: ElevatedButton(
                onPressed: () {
                  // Logic for saving profile information
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (context) => LoginPage()),
                    (Route<dynamic> route) => false, // Menghapus semua route sebelumnya
                  );
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFB3907A),
                  padding: EdgeInsets.symmetric(vertical: 16, horizontal: 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                    side: BorderSide(color: Colors.black),
                  ),
                ),
              ),
            ),

            SizedBox(height: 20), // Menambahkan jarak tambahan di bawah tombol Save
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
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB3907A),
          ),
        ),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF5F5EB),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
        Divider(
          color: Color(0xFFB3907A),
        ),
      ],
    );
  }

  Widget _buildDateOfBirthField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
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
            fillColor: Color(0xFFF5F5EB),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            suffixIcon: IconButton(
              icon: Icon(Icons.calendar_today, color: Color(0xFFB3907A)),
              onPressed: () async {
                DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(1900),
                  lastDate: DateTime(2100),
                  builder: (context, child) {
                    return Theme(
                      data: ThemeData.dark().copyWith(
                        primaryColor: Colors.white, // Tombol OK/Cancel hitam
                        textButtonTheme: TextButtonThemeData(
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.black, // Warna teks tombol
                            textStyle: TextStyle(decoration: TextDecoration.none), // Menghapus underline
                          ),
                        ),
                      ),
                      child: child!,
                    );
                  },
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
        Divider(
          color: Color(0xFFB3907A),
        ),
      ],
    );
  }

  Widget _buildGenderDropdown() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Gender',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFFB3907A),
          ),
        ),
        DropdownButtonFormField<String>(
          value: selectedGender,
          items: ['Male', 'Female']
              .map((gender) => DropdownMenuItem<String>(
                    value: gender,
                    child: Text(gender),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              if (value != null) selectedGender = value;
            });
          },
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFF5F5EB),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          icon: Icon(Icons.arrow_drop_down, color: Color(0xFFB3907A)),
        ),
        Divider(
          color: Color(0xFFB3907A),
        ),
      ],
    );
  }
}