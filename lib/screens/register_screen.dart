// ignore_for_file: file_names
//import 'dart:typed_data';
//import 'package:flutter_svg/flutter_svg.dart';
//import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';

//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lostthingfindapplication/resources/auth_methods.dart';
//import 'package:lostthingfindapplication/responsive/mobile_screen_layout.dart';
//import 'package:lostthingfindapplication/responsive/reponsive_layout_screen.dart';
//import 'package:lostthingfindapplication/responsive/web_screen_layout.dart';
import 'package:lostthingfindapplication/screens/login_screen.dart';
import 'package:lostthingfindapplication/utils/colors.dart';
import 'package:lostthingfindapplication/utils/utils.dart';
import 'package:lostthingfindapplication/widgets/text_field_input.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _contactnoController = TextEditingController();
  bool _isLoading = false;
  Uint8List? _image;

  @override
  void dispose() {
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _usernameController.dispose();
    //_contactnoController.dispose();
  }

  void signUpUser() async {
    // set loading to true
    setState(() {
      _isLoading = true;
    });

    // signup user using our authmethodds
    String res = await AuthMethods().signUpUser(
        email: _emailController.text,
        password: _passwordController.text,
        username: _usernameController.text,
        contactNo: _contactnoController.text,
        file: _image!);

    setState(() {
      _isLoading = false;
    });

    // if string returned is sucess, user has been created
    if (res == "success") {
      setState(() {
        _isLoading = false;
      });
      // navigate to the home screen
      if (context.mounted) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => const LoginScreen(
                //mobileScreenLayout: MobileScreenLayout(),
                //webScreenLayout: WebScreenLayout(),
                ),
          ),
        );
      }
    } else {
      setState(() {
        _isLoading = false;
      });
      // show the error
      if (context.mounted) {
        showSnackBar(context, res);
      }
    }
  }

  selectImage() async {
    Uint8List im = await pickImage(ImageSource.gallery);
    setState(() {
      _image = im;
    });
  }

  void navigateToLogin() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            width: double.infinity,
            height: MediaQuery.of(context).size.height,
            color: mobileBackgroundColor, // Added background color
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(flex: 1, child: Container()),
                const SizedBox(height: 20),
                // Image
                Image.asset(
                  'assets/namer.png',
                  color: primaryColor,
                  height: 64,
                ),
                const SizedBox(height: 24),
                // Circular widget to accept and show our selected file
                Stack(
                  children: [
                    _image != null
                        ? CircleAvatar(
                            radius: 64,
                            backgroundImage: MemoryImage(_image!),
                            backgroundColor:
                                const Color.fromARGB(255, 167, 153, 152),
                          )
                        : const CircleAvatar(
                            radius: 64,
                            backgroundImage: NetworkImage(
                                'https://i.stack.imgur.com/l60Hf.png'),
                            backgroundColor: Color.fromARGB(255, 194, 183, 183),
                          ),
                    Positioned(
                      bottom: -10,
                      left: 80,
                      child: IconButton(
                        onPressed: selectImage,
                        icon: const Icon(
                          Icons.add_a_photo,
                        ),
                        color: Colors.black,
                        iconSize: 35,
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 20),
                // Text field input for username
                TextFieldInput(
                  textEditingController: _usernameController,
                  hintText: "Enter your username",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 10),
                // Text field input for email
                TextFieldInput(
                  textEditingController: _emailController,
                  hintText: "Enter your email",
                  textInputType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 10),
                // Text field input for password
                TextFieldInput(
                  textEditingController: _passwordController,
                  hintText: "Enter your password",
                  textInputType: TextInputType.text,
                  isPass: true,
                ),
                const SizedBox(height: 10),
                // Text field input for contact number
                TextFieldInput(
                  textEditingController: _contactnoController,
                  hintText: "Enter your contact No.",
                  textInputType: TextInputType.text,
                ),
                const SizedBox(height: 24),
                InkWell(
                  onTap: signUpUser,
                  child: Container(
                    width: double.infinity,
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      gradient: LinearGradient(
                        colors: [
                          Color.fromARGB(255, 54, 17, 216),
                          secondaryColor,
                        ],
                      ),
                    ),
                    child: _isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          )
                        : const Text(
                            "Sign Up",
                            style: TextStyle(
                              color: primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 16),
                Flexible(flex: 1, child: Container()),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: const Text("Already have an account? "),
                    ),
                    GestureDetector(
                      onTap: navigateToLogin,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: const Text(
                          "Login ",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 251, 80, 42),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Flexible(flex: 1, child: Container()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
