import 'package:cloud_firestore/cloud_firestore.dart';

class User{
  final String email;
  final String photoUrl;
  final String uid;
  final String contactNo;
  final String username;
  
  const User ({
    required this.email,
    required this.photoUrl,
    required this.uid,
    required this.contactNo,
    required this.username,
  });

  Map <String, dynamic> toJson() =>{
    "username" :username,
    'contactNo' :contactNo,
    'uid' :uid,
    'photoUrl' :photoUrl,
    'email' :email,
  };

  static User fromSnap(DocumentSnapshot snap){
    var snapshot = snap.data() as Map <String, dynamic>;

    return User(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      photoUrl: snapshot['photoUrl'],
      contactNo: snapshot['contactNo'],
    );
  }

   
}