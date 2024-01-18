import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  final TextEditingController textEditingController;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  const TextFieldInput(
      {super.key,
      required this.textEditingController,
      required this.hintText,
      this.isPass = false,
      required this.textInputType});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: textEditingController,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle:
            const TextStyle(fontWeight: FontWeight.normal,
              color: Colors.grey), // Set your desired hint text color
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: const BorderSide(color: Colors.pinkAccent, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
          borderSide: BorderSide.none,
        ),
        filled: true,
        fillColor: const Color.fromARGB(255, 255, 240, 245), // Light Pink
        contentPadding: const EdgeInsets.all(16),
      ),
      keyboardType: textInputType,
      obscureText: isPass,
      style: const TextStyle(fontSize: 16, color: Colors.black87),
    );
  }
}
