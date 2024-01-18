import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lostthingfindapplication/utils/colors.dart';
import 'package:lostthingfindapplication/widgets/post_card.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController searchController = TextEditingController();
  bool isShowPosts = false;
  @override
  void dispose() {
    super.dispose();
    searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: TextFormField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search for post',
          ),
          onFieldSubmitted: (String _) {
            setState(() {
              isShowPosts = true;
            });
          },
        ),
      ),
      body: isShowPosts
          ? FutureBuilder(
              future: FirebaseFirestore.instance
                  .collection('posts')
                  .where(
                    'title',
                    isEqualTo: searchController.text,
                  )
                  .get(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView.builder(
                  itemCount: (snapshot.data! as dynamic).docs.length,
                  itemBuilder: (context, index) => PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              },
            )
          : const Center(
              child: Text(
                'No posts available.',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey,
                ),
              ),
            ),
    );
  }
}
