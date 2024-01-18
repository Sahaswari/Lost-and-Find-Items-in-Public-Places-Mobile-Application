//import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

pickImage(ImageSource source) async{
  final ImagePicker imagePicker =ImagePicker();
  XFile? file = await imagePicker.pickImage(source: source);

  if(file != null){
    return await file.readAsBytes();
  }
  // ignore: avoid_print
  print("No image selected!");
}

void showSnackBar(BuildContext context, String text) {
  if (text.contains("]")) {
    // Extract the part after "]"
    text = text.split("]")[1].trim();
  }
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.pinkAccent, // Customize the background color
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
    ),
  );
}

