import 'package:cloud_firestore/cloud_firestore.dart';

class Post{
  final String description;
  final String title;
  final String uid;
  final String username;
  final String contactNo;
  // ignore: prefer_typing_uninitialized_variables
  final datePublished;
  // ignore: prefer_typing_uninitialized_variables
  final timePublished;
  final String postUrl;
  final String profImage;
  final String? category;
  // ignore: prefer_typing_uninitialized_variables
  final date;
  final String location;
  final String postId;
  final bool isLost;
  
  const Post ({
    required this.category, 
    required this.date, 
    required this.description, 
    required this.title, 
    required this.datePublished, 
    required this.timePublished, 
    required this.postUrl, 
    required this.profImage, 
    required this.uid,
    required this.contactNo,
    required this.username, 
    required this.location,
    required this.postId,
    required this.isLost,
  });

  Map <String, dynamic> toJson() =>{
    "username" :username,
    'contactNo' :contactNo,
    'uid' :uid,
    'postUrl' :postUrl,
    'description':description,
    'title' :title,
    'datePublished' :datePublished,
    'timePublished' :timePublished,
    'profImage' :profImage,
    'category' :category,
    'date':date,
    'location' :location,
    'postId':postId,
    'isLost':isLost,
  };

  static Post fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map <String, dynamic>;

    return Post(
      username: snapshot['username'],
      uid: snapshot['uid'],
      description: snapshot['description'],
      postUrl: snapshot['postUrl'],
      contactNo: snapshot['contactNo'],
      datePublished: snapshot['datePublished'],
      timePublished: snapshot['timePublished'],
      profImage: snapshot['profImage'],
      title: snapshot['title'], 
      postId: snapshot['postId'],
      date: snapshot['date'],
      category: snapshot['category'],
      location: snapshot['location'],
      isLost:snapshot['isLost'],
    );
  }

   
}