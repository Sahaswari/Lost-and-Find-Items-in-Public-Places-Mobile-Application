import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
//import 'package:lostthingfindapplication/models/user.dart';
import 'package:lostthingfindapplication/providers/user_provider.dart';
import 'package:lostthingfindapplication/resources/firestore_method.dart';
import 'package:lostthingfindapplication/screens/found_item_screen.dart';
//import 'package:lostthingfindapplication/screens/login_screen.dart';
import 'package:lostthingfindapplication/screens/lost_item_screen.dart';
import 'package:lostthingfindapplication/utils/colors.dart';
import 'package:lostthingfindapplication/utils/utils.dart';
import 'package:provider/provider.dart';

class AddPostScreen extends StatefulWidget {
  const AddPostScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  Uint8List? _file;
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  //final TextEditingController _dateController = TextEditingController();
  //final TextEditingController _categoryController = TextEditingController();

  bool _isLoading = false;

  DateTime selectedDate = DateTime.now(); // Initialize with the current date
  bool isLost = true;

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate);
        ;
      });
    }
  }

  String? _selectedCategory;

  final List<String> _categories = [
    'Electronic',
    'Animals',
    'Personal Category',
    'Bags',
    'Other'
  ]; // Add your categories

  void postImage(
    String uid,
    String username,
    String profImage,
    String contactNo,
  ) async {
    setState(() {
      _isLoading = true;
    });
    try {
      String res = await FirestoreMethods().uploadPost(
        _descriptionController.text,
        _file!,
        uid,
        username,
        profImage,
        _titleController.text,
        contactNo,
        _locationController.text,
        //_categoryController.text,
        _selectedCategory,
        selectedDate,
        isLost,
      );

      if (res == "success") {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(
          context,
          'Posted!',
        );
        clearImage();
        if(isLost==true) {
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LostItemsScreen()
          ),
          );
        }
        else {
          Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const FoundItemsScreen()
          ),
          );
        }
      } else {
        setState(() {
          _isLoading = false;
        });
        // ignore: use_build_context_synchronously
        showSnackBar(context, res);
      }
    } catch (e) {
      // ignore: use_build_context_synchronously
      showSnackBar(context, toString());
    }
  }

  _selectImage(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: const Text('Create a Post'),
            children: [
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Take a photo'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.camera,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Choose from Gallery'),
                onPressed: () async {
                  Navigator.of(context).pop();
                  Uint8List file = await pickImage(
                    ImageSource.gallery,
                  );
                  setState(() {
                    _file = file;
                  });
                },
              ),
              SimpleDialogOption(
                padding: const EdgeInsets.all(20),
                child: const Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void clearImage() {
    setState(() {
      _file = null;
    });
  }

  @override
  void dispose() {
    super.dispose();
    _descriptionController.dispose();
    // _categoryController.dispose();
    _locationController.dispose();
    _dateController.dispose();
    _titleController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);

    return _file == null
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.drive_folder_upload_outlined,
                      size: 48, color: blueColor),
                  onPressed: () => _selectImage(context),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Upload Your Post',
                  style: TextStyle(
                    color: secondaryColor,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          )
        : Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.blue, // Change to your desired color
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {},
              ),
              title: const Text('Post to'),
              centerTitle: false,
              actions: [],
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  _isLoading
                      ? const LinearProgressIndicator()
                      : const Padding(
                          padding: EdgeInsets.only(top: 0),
                        ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      userProvider.getUser.photoUrl,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 30),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Selected Image',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Container(
                                height: 80,
                                width: 80,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: _file != null
                                      ? DecorationImage(
                                          image: MemoryImage(_file!),
                                          fit: BoxFit.cover,
                                          alignment: FractionalOffset.topCenter,
                                        )
                                      : null,
                                  color: Colors.grey[
                                      200], // Adjust color as per your design
                                ),
                                child: _file == null
                                    ? const Icon(
                                        Icons.add_a_photo,
                                        color: Colors.grey,
                                        size: 36,
                                      )
                                    : const SizedBox(),
                              ),
                            ],
                          ),
                        ),
                        const Divider(),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 193, 205,
                                209), // Adjust color as per your design
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextField(
                              controller: _titleController,
                              style: const TextStyle(
                                  color: Colors.black), // Adjust text color
                              decoration: const InputDecoration(
                                hintText: 'Title...',
                                border: InputBorder.none,
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 50, 59,
                                        113)), // Change the color to your desired color
                              ),
                              maxLength: 50,
                              maxLines: null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: MediaQuery.of(context).size.width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: Colors.indigo,
                          width: 2.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: DropdownButtonFormField<String>(
                          value: _selectedCategory,
                          onChanged: (String? newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                          items: _categories
                              .map<DropdownMenuItem<String>>((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          decoration: const InputDecoration(
                            hintText: 'Select Item Category',
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 50, 59,
                                    113)), // Change the color to your desired color

                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 205,
                            209), // Adjust color as per your design
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _descriptionController,
                          style: const TextStyle(
                              color: Colors.black), // Adjust text color
                          decoration: const InputDecoration(
                            hintText: 'Description...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 50, 59,
                                    113)), // Change the color to your desired color
                          ),
                          maxLength: 150,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 205, 209),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _dateController,
                                style: const TextStyle(
                                  color: Colors.black,
                                ),
                                decoration: const InputDecoration(
                                  hintText: 'Select Lost/Found Date',
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 50, 59, 113),
                                  ),
                                ),
                                onTap: () => _selectDate(context),
                                readOnly: true,
                              ),
                            ),
                            IconButton(
                              icon: const Icon(Icons.calendar_today,
                                  size: 20, color: blueColor),
                              onPressed: () => _selectDate(context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 193, 205,
                            209), // Adjust color as per your design
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TextField(
                          controller: _locationController,
                          style: const TextStyle(
                              color: Colors.black), // Adjust text color
                          decoration: const InputDecoration(
                            hintText: 'Location Lost/Found...',
                            border: InputBorder.none,
                            hintStyle: TextStyle(
                                color: Color.fromARGB(255, 50, 59,
                                    113)), // Change the color to your desired color
                          ),
                          maxLength: 50,
                          maxLines: null,
                        ),
                      ),
                    ),
                  ),
                  const Divider(),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: isLost ? Colors.redAccent : Colors.greenAccent,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLost = false;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  bottomLeft: Radius.circular(20),
                                ),
                                color:
                                    isLost ? Colors.transparent : Colors.white,
                              ),
                              child: Text(
                                'Found Item',
                                style: TextStyle(
                                  color: isLost ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                isLost = true;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 10),
                              decoration: BoxDecoration(
                                borderRadius: const BorderRadius.only(
                                  topRight: Radius.circular(20),
                                  bottomRight: Radius.circular(20),
                                ),
                                color:
                                    isLost ? Colors.white : Colors.transparent,
                              ),
                              child: Text(
                                'Lost Item',
                                style: TextStyle(
                                  color: isLost ? Colors.black : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const Divider(),
                  const SizedBox(height: 20),
                  Text('Selected: ${isLost ? 'Lost Item' : 'Found Item'}'),
                  ElevatedButton(
                    onPressed: () => postImage(
                      userProvider.getUser.uid,
                      userProvider.getUser.username,
                      userProvider.getUser.photoUrl,
                      userProvider.getUser.contactNo,
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.indigo, // Button color
                      onPrimary: Colors.yellow, // Text color
                      textStyle: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      elevation: 5,
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.post_add, size: 24),
                        SizedBox(width: 8),
                        Text('Post'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
  }
}
