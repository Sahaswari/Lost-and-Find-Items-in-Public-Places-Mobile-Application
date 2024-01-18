import "package:firebase_auth/firebase_auth.dart";
import "package:flutter/material.dart";
import "package:lostthingfindapplication/screens/add_post_screen.dart";
import 'package:lostthingfindapplication/screens/lost_item_screen.dart';
import 'package:lostthingfindapplication/screens/found_item_screen.dart';
import "package:lostthingfindapplication/screens/profile_screen.dart";
import "package:lostthingfindapplication/screens/search_screen.dart";

const webScreenSize = 600;

List<Widget> homeScreenItems = [
  const LostItemsScreen(),
  const FoundItemsScreen(),
  const AddPostScreen(),
  const SearchScreen(),
  ProfileScreen(
    uid: FirebaseAuth.instance.currentUser!.uid,
  ),
];
