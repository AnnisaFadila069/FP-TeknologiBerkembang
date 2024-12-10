// File: custom_widgets.dart

import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final TextEditingController? controller; // Dapat berupa null
  final int maxLines;
  final ValueChanged<String>? onChanged; // Tambahkan properti onChanged

  const CustomTextField({
    Key? key,
    required this.label,
    required this.hintText,
    this.controller, // Tetap opsional
    this.maxLines = 1,
    this.onChanged, // Tambahkan onChanged ke konstruktor
  }) : super(key: key);

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
              color: Color(0xFF7B7B7D), // Warna teks label
            ),
          ),
          const SizedBox(height: 4),
          TextField(
            controller: controller, // Gunakan nilai opsional
            maxLines: maxLines,
            onChanged: onChanged, // Panggil onChanged 
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFFE1DACA), // Warna latar belakang kotak
              hintText: hintText,
              hintStyle: const TextStyle(
                color: Colors.grey, // Warna teks hint
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none, // Hapus border
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
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
              color: Color(0xFF7B7B7D), // Warna teks label
            ),
          ),
          const SizedBox(height: 4),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFE1DACA), // Warna latar belakang kotak
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
                        fontWeight: FontWeight.w400,
                        color: Colors.black, // Warna teks item dropdown
                      ),
                    ),
                  );
                }).toList(),
                onChanged: onChanged,
                dropdownColor: const Color(0xFFF5F5EB), // Warna latar dropdown
              ),
            ),
          ),
        ],
      ),
    );
  }
}
