// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/widgets/profile_image_homepage.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

import 'package:chat_app/models/usersmodel.dart';

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
        child: LogedInUserPic(),
      ),
    );
  }
}
