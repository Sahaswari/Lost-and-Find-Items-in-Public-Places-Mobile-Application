//import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lostthingfindapplication/resources/firestore_method.dart';
import 'package:lostthingfindapplication/screens/comment_screen.dart';
//import 'package:lostthingfindapplication/utils/colors.dart';
//import 'package:lostthingfindapplication/utils/utils.dart';
//import 'package:flutter/src/rendering/box.dart';

class PostCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final snap;
  const PostCard({required this.snap, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  int commentLen = 0;

  @override
  void initState() {
    super.initState();
    //getComments();
  }

//   void getComments() async {
//     try {
//       QuerySnapshot snap = await FirebaseFirestore.instance
//           .collection('posts')
//           .doc(widget.snap['postId'])
//           .collection('comments')
//           .get();
//       commentLen = snap.docs.length;
//     } catch (err) {
// (context, err.toString(),);
//     }
//     setState(() {});
//   }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: const Color.fromRGBO(62, 61, 93, 0.277),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(widget.snap['profImage']),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.snap['username'],
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (context) => Dialog(
                        child: ListView(
                          shrinkWrap: true,
                          children: ['Delete']
                              .map((e) => InkWell(
                                    onTap: () async {
                                      FirestoreMethods()
                                          .deletePost(widget.snap['postId']);
                                      Navigator.of(context).pop();
                                    },
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 16),
                                      child: Text(e),
                                    ),
                                  ))
                              .toList(),
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.more_vert),
                ),
              ],
            ),
          ),
          const Divider(),
          // Image section
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.35, 
            width: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(12.0), 
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.network(
                  widget.snap['postUrl'],
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          
          // Comments section
          Padding(
            padding: const EdgeInsets.only(left:12),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.comment_outlined),
                  onPressed: () => Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => CommentScreen(
                        postId: widget.snap['postId'].toString(),
                      ),
                    ),
                  ),
                ),
                Text(
                  DateFormat.yMMMd()
                      .format(widget.snap['datePublished'].toDate()),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 20),
                Text(
                  DateFormat('HH:mm:a')
                      .format(widget.snap['timePublished'].toDate()),
                  style: const TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),

          const Divider(),
          // Title
          Padding(
            padding: const EdgeInsets.only(left: 12,top:10),
            child: Text(
              "Title: ${widget.snap['title']}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12,top:10),
            child: Text(
              "Category: ${widget.snap['category']}",
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
          // See more button
          Padding(
            padding: const EdgeInsets.all(12),
            child: InkWell(
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => Dialog(
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        // Title
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Title: ${widget.snap['title']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Category
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Category: ${widget.snap['category']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Location
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Location: ${widget.snap['location']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Date
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Date: ${DateFormat.yMMMd().format(widget.snap['date'].toDate())}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Description
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Description: ${widget.snap['description']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        // Contact No
                        Padding(
                          padding: const EdgeInsets.all(12),
                          child: Text(
                            "Contact No: ${widget.snap['contactNo']}",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    "See more",
                    style: TextStyle(
                      color: Color.fromARGB(255, 1, 38, 101),
                      fontWeight: FontWeight.normal,
                      fontSize: 12,
                    ),
                  ),
                  Icon(Icons.more_horiz, color: Color.fromARGB(255, 1, 38, 101)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
