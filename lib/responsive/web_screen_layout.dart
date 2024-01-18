import 'package:flutter/material.dart';

// ignore: camel_case_types
class WebScreenLayout extends StatefulWidget {
  const WebScreenLayout({super.key});

  @override
  State<WebScreenLayout> createState() => _WebScreenLayoutState();
}

class _WebScreenLayoutState extends State<WebScreenLayout> {
  @override
  Widget build(BuildContext context) {
     return const Scaffold(
      body:SafeArea(
        child: Center(child:Text("This is web"),
        ),
      ),
    );
  }
}
