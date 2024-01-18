import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:lostthingfindapplication/models/post.dart';
import 'package:lostthingfindapplication/resources/storage_methods.dart';
import 'package:uuid/uuid.dart';

class FirestoreMethods {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //upload the post
  Future<String> uploadPost(
    String description,
    Uint8List file,
    String uid,
    String username,
    String profImage,
    String title,
    String contactNo,
    String location,
    String? category,
    DateTime date,
    bool isLost,
  ) async {
    String res = 'some error occurred.';
    try {
      String photoUrl =
          await StorageMethods().uploadImageToStorage('posts', file, true);

      String postId = const Uuid().v1();
      Post post = Post(
        description: description,
        uid: uid,
        username: username,
        postUrl: photoUrl,
        datePublished: DateTime.now(),
        timePublished: DateTime.now(),
        postId: postId,
        profImage: profImage,
        title: title,
        contactNo: contactNo,
        category: category,
        location: location,
        date: date,
        isLost: isLost,
      );

      _firestore.collection('posts').doc(postId).set(
            post.toJson(),
          );

      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }

   Future<String> postComment(String postId, String text, String uid,
      String name, String profilePic) async {
    String res = "Some error occurred";
    try {
      if (text.isNotEmpty) {
        // if the likes list contains the user uid, we need to remove it
        String commentId = const Uuid().v1();
        _firestore
            .collection('posts')
            .doc(postId)
            .collection('comments')
            .doc(commentId)
            .set({
          'profilePic': profilePic,
          'name': name,
          'uid': uid,
          'text': text,
          'commentId': commentId,
          'datePublished': DateTime.now(),
        });
        res = 'success';
      } else {
        res = "Please enter text";
      }
    } catch (err) {
      res = err.toString();
    }
    return res;
  }


  //deleting a post

  Future<String> deletePost(String postId) async {
    String res = "Some error occurred";
    try {
      await _firestore.collection('posts').doc(postId).delete();
      res = 'success';
    } catch (err) {
      res = err.toString();
    }
    return res;
  }
}
