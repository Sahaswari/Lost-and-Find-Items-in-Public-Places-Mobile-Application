import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lostthingfindapplication/widgets/post_card.dart';

class LostItemsScreen extends StatefulWidget {
  const LostItemsScreen({super.key});

  @override
  State<LostItemsScreen> createState() => _LostItemsScreenState();
}

class _LostItemsScreenState extends State<LostItemsScreen> {
  @override
  Widget build(BuildContext context) {
    //final width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (!snapshot.hasData ||
              snapshot.data == null ||
              snapshot.data!.docs.isEmpty) {
            // Handle the case where there is no data
            return const Center(
              child: Text('No data available'),
            );
          }

          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              Map<String, dynamic> postData = snapshot.data!.docs[index].data();
              bool isPostLost = postData['isLost'];

              if (isPostLost) {
                return PostCard(snap: postData);
              } else {
                return  Container();
              }
            },
          );
        },
      ),
    );
  }
}
