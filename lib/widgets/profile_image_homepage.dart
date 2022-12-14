import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogedInUserPic extends StatefulWidget {
  const LogedInUserPic({Key? key}) : super(key: key);

  @override
  State<LogedInUserPic> createState() => _LogedInUserPicState();
}

class _LogedInUserPicState extends State<LogedInUserPic> {
  Stream<DocumentSnapshot> _imageStream() {
    return FirebaseFirestore.instance
        .collection("Users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _imageStream(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.none) {
          return Text("No Internet Connection");
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (!snapshot.hasData) {
          return Icon(Icons.person);
        }
        dynamic data = snapshot.data;
        return CircleAvatar(
          maxRadius: 80,
          backgroundImage: NetworkImage(data['profilepic']),
        );
      },
    );
  }
}
