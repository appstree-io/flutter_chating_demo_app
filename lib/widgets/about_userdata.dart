import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class UserAbout extends StatefulWidget {
  const UserAbout({super.key});

  @override
  State<UserAbout> createState() => _UserAboutState();
}

class _UserAboutState extends State<UserAbout> {
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
        return Text(
          (data['about'] == null) ? "" : data['about'],
        );
      },
    );
  }
}
