// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:chat_app/main.dart';
import 'package:chat_app/models/messagemodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

import '../models/chatroommodel.dart';

class PreviewImage extends StatefulWidget {
  final XFile? picture;
  final ChatRoomModel chatroom;
  final User currentuser;
  const PreviewImage({
    Key? key,
    required this.picture,
    required this.chatroom,
    required this.currentuser,
  }) : super(key: key);

  @override
  State<PreviewImage> createState() => _PreviewImageState();
}

class _PreviewImageState extends State<PreviewImage> {
  void sendMessage() async {
    final File msgfile = File(widget.picture!.path);

    UploadTask uploadTask = FirebaseStorage.instance
        .ref("messagepics")
        .child(widget.currentuser.uid.toString())
        .putFile(msgfile);

    TaskSnapshot snapshot = await uploadTask;

    String? imgUrl = await snapshot.ref.getDownloadURL();

    MessageModel newMessage = MessageModel(
      messageid: uuid.v1(),
      messageimage: widget.picture,
      msgimg: imgUrl,
      sender: widget.currentuser.uid,
      seen: false,
      timecreated: DateTime.now(),
    );
    await FirebaseFirestore.instance
        .collection("Chatrooms")
        .doc(widget.chatroom.chatroomid)
        .collection("Messages")
        .doc(newMessage.messageid)
        .set(newMessage.toJson());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          sendMessage();
        },
        backgroundColor: Color(0xff2865DC),
        child: Center(
          child: Image.asset(
            "assets/send1.png",
            width: 38,
            color: Colors.white,
            //height: 70,
          ),
        ),
      ),
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text(
          'Send Image',
        ),
        backgroundColor: Colors.black,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.file(
              File(widget.picture!.path),
              fit: BoxFit.contain,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height * 0.8,
            ),
            const SizedBox(height: 24),
            Text(widget.picture!.name)
          ],
        ),
      ),
    );
  }
}
