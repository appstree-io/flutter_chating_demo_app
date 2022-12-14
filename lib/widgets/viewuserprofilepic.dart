// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/widgets/profile_image_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';
import 'package:chat_app/models/usersmodel.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ViewUserProfilePic extends StatefulWidget {
  const ViewUserProfilePic({
    Key? key,
  }) : super(key: key);

  @override
  State<ViewUserProfilePic> createState() => _ViewUserProfilePicState();
}

class _ViewUserProfilePicState extends State<ViewUserProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        toolbarHeight: 60,
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: UserProfilePic(),
      ),
    );
  }
}

class UserProfilePic extends StatefulWidget {
  const UserProfilePic({super.key});

  @override
  State<UserProfilePic> createState() => _UserProfilePicState();
}

class _UserProfilePicState extends State<UserProfilePic> {
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
        return Image.network(
          data['profilepic'],
        );
      },
    );
  }
}
