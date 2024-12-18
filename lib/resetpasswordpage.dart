import 'package:flutter/material.dart';
import 'loginpage.dart'; // Pastikan LoginPage sudah diimpor

class ResetPasswordPage extends StatelessWidget {
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDF6EC),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF5F5EB),
        elevation: 0,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 170.0), // Atur jarak ke atas
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Logo di tengah
                    Image.asset(
                      'Image/logo_bookmate.png',
                      width: 100,
                      height: 100,
                    ),
                    const SizedBox(height: 10),
                    // Tulisan BookMate
                    const Text(
                      'BookMate',
                      style: TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    const SizedBox(height: 30), // Jarak antara tulisan dan form

                    // Form New Password dan Confirm Password
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        children: [
                          TextField(
                            controller: newPasswordController,
                            decoration: InputDecoration(
                              hintText: 'New Password',
                              filled: true,
                              fillColor: const Color(0xFFE4DECF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 15),
                          TextField(
                            controller: confirmPasswordController,
                            decoration: InputDecoration(
                              hintText: 'Confirm Password',
                              filled: true,
                              fillColor: const Color(0xFFE4DECF),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 12),
                            ),
                            obscureText: true,
                          ),
                          const SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Tambahkan logika untuk memeriksa kecocokan password
                              if (newPasswordController.text == confirmPasswordController.text) {
                                // Jika password cocok, navigasi ke halaman login
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginPage()), // Pindah ke halaman login
                                  (Route<dynamic> route) => false, // Hapus semua halaman sebelumnya dari stack
                                );
                              } else {
                                // Jika password tidak cocok, tampilkan dialog error
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text('Error'),
                                      content: const Text('Passwords do not match!'),
                                      actions: [
                                        TextButton(
                                          child: const Text('OK'),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                        ),
                                      ],
                                    );
                                  },
                                );
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFE4DECF),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                                side: const BorderSide(color: Colors.black),
                              ),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}