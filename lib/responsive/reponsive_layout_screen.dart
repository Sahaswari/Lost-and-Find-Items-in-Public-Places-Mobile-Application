import 'package:flutter/material.dart';
import 'package:lostthingfindapplication/providers/user_provider.dart';
//import 'package:flutter/rendering.dart';
import 'package:lostthingfindapplication/utils/global_variable.dart';
import 'package:provider/provider.dart';

class ResponsiveLayout extends StatefulWidget {
  final Widget webScreenLayout;
  final Widget mobileScreenLayout;
  const ResponsiveLayout({Key? key, required this.webScreenLayout, required this.mobileScreenLayout}) :super(key:key);

  @override
  State<ResponsiveLayout> createState() => _ResponsiveLayoutState();
}

class _ResponsiveLayoutState extends State<ResponsiveLayout> {
  @override
  void initState(){
    super.initState();
    addData();
  }

  addData( ) async {
    UserProvider userProvider = Provider.of(context,listen:false);
    await userProvider.refreshUser();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      // ignore: avoid_types_as_parameter_names, non_constant_identifier_names
      builder: (context, Constraints){
        if(Constraints.maxWidth>webScreenSize){
          return widget.webScreenLayout;
          //webScreen 
        }
        return widget.mobileScreenLayout;
          //mobile screen
      },
    );
  }
}