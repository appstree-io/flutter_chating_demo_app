// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/usersmodel.dart';
import 'package:chat_app/widgets/listusers_addbutton.dart';

class SelectUserToChat extends StatefulWidget {
  final User? chatUser;

  const SelectUserToChat({
    Key? key,
    required this.chatUser,
  }) : super(key: key);

  @override
  State<SelectUserToChat> createState() => _SelectUserToChatState();
}

class _SelectUserToChatState extends State<SelectUserToChat> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff2865DC),
        toolbarHeight: 130,
        title: Text("Select any User to Chat"),
      ),
      body: Container(child: ChatList(chatUser: widget.chatUser!)),
    );
  }
}
