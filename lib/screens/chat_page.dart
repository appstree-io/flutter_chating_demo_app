// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/chatroommodel.dart';
import 'package:chat_app/models/messagemodel.dart';
import 'package:chat_app/widgets/showmessage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:chat_app/models/chatgroupmodel.dart';
import 'package:chat_app/models/usersmodel.dart';

class ChatPage extends StatefulWidget {
  final ChatUser targetuser;
  final ChatRoomModel chatroom;
  final ChatUser currentuser;
  final User firebaseuser;

  const ChatPage({
    Key? key,
    required this.targetuser,
    required this.chatroom,
    required this.currentuser,
    required this.firebaseuser,
  }) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  var _focusNode = FocusNode();

  focusListener() {
    setState(() {});
  }

  @override
  void initState() {
    _focusNode.addListener(focusListener);
    super.initState();
  }

  @override
  void dispose() {
    _focusNode.removeListener(focusListener);
    super.dispose();
  }

  TextEditingController msgcontroller = TextEditingController();

  void sendmessage() async {
    String message = msgcontroller.text.trim();
    msgcontroller.clear();
    if (message != "") {
      MessageModel newMessage = MessageModel(
        messageid: uuid.v1(),
        messagetext: message,
        sender: widget.currentuser.uid,
        seen: false,
        timecreated: DateTime.now(),
      );

      FirebaseFirestore.instance
          .collection("Chatrooms")
          .doc(widget.chatroom.chatroomid)
          .collection("Messages")
          .doc(newMessage.messageid)
          .set(newMessage.toJson());

      widget.chatroom.lastmessage = message;

      FirebaseFirestore.instance
          .collection("Chatrooms")
          .doc(widget.chatroom.chatroomid)
          .set(widget.chatroom.toJson());

      log("Message sent");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffF5F5F5),
      appBar: AppBar(
        shadowColor: Colors.transparent,
        toolbarHeight: 100,
        elevation: 5,
        scrolledUnderElevation: 5,
        backgroundColor: Color(0xffFFFFFF),
        automaticallyImplyLeading: true,
        leading: BackButton(color: Colors.black),
        title: SizedBox(
          width: 290,
          height: 59,
          child: Row(
            children: [
              SizedBox(
                width: 65,
                height: 70,
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage:
                      NetworkImage(widget.targetuser.profilepic.toString()),
                  //  child: Image.network(widget.image!),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.targetuser.username.toString(),
                    style: GoogleFonts.inter(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff222222),
                    ),
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  Text(
                    'Last seen 3:04 pm',
                    style: GoogleFonts.inter(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: Color(0xff414141),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
        actions: [
          Row(
            children: [
              Image.asset(
                'assets/video.png',
                height: 35,
                width: 35,
              ),
              const SizedBox(
                width: 6,
              ),
              Image.asset(
                'assets/more.png',
                height: 35,
                width: 35,
              ),
            ],
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                child: ShowMessages(
                  chatroom: widget.chatroom,
                  chatuser: widget.currentuser,
                  targetuser: widget.targetuser,
                ),
              ),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 20, left: 20),
                    width: MediaQuery.of(context).size.width - 100,
                    height: 60,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Color(0xffF3F3F3),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xffDBDBDB),
                          blurRadius: 15,
                          spreadRadius: 1.5,
                        ),
                      ],
                    ),
                    child: TextFormField(
                      keyboardAppearance: Brightness.dark,
                      //textInputAction: TextInputAction.continueAction,
                      controller: msgcontroller,
                      maxLines: 35,
                      focusNode: _focusNode,
                      decoration: InputDecoration(
                        hintText: 'Message...',
                        hintStyle: GoogleFonts.inter(
                          fontSize: 16,
                          color: Color(0xffB5B4B4),
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.only(
                          top: 19,
                          left: 20,
                        ),
                        prefixIcon: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, left: 10, right: 10),
                          child: Image.asset(
                            "assets/smile.png",
                            color: Colors.black,
                            height: 27,
                            width: 27,
                          ),
                        ),
                        suffixIcon: Padding(
                          padding:
                              const EdgeInsets.only(top: 0, left: 3, right: 15),
                          child: Image.asset(
                            "assets/camera.png",
                            height: 27,
                            width: 27,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      bottom: 10,
                      right: 0,
                      left: 10,
                    ),
                    child: FloatingActionButton(
                      elevation: 15,
                      onPressed: () {},
                      child: ElevatedButton(
                        onPressed: () {
                          sendmessage();
                        },
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(10),
                          onPrimary: Color(0xffFFFFFF),
                          onSurface: Color(0xff2865DC),
                          primary: Color(0xff2865DC),
                        ),
                        child: Image.asset(
                          "assets/mic.png",
                          height: 36,
                          width: 27,
                        ),
                      ),
                    ),
                  ),
                ]),
          ],
        ),
      ),
    );
  }
}
