// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:chat_app/models/messagemodel.dart';
import 'package:chat_app/widgets/viewmessagepicture.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/chatroommodel.dart';
import 'package:chat_app/models/usersmodel.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class ShowMessages extends StatefulWidget {
  final ChatRoomModel chatroom;
  final User chatuser;
  final ChatUser targetuser;

  const ShowMessages({
    Key? key,
    required this.chatroom,
    required this.chatuser,
    required this.targetuser,
  }) : super(key: key);

  @override
  State<ShowMessages> createState() => _ShowMessagesState();
}

class _ShowMessagesState extends State<ShowMessages> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection("Chatrooms")
            .doc(widget.chatroom.chatroomid)
            .collection("Messages")
            .orderBy("timecreated", descending: true)
            .snapshots(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            if (snapshot.hasData) {
              QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
              return ListView.builder(
                  reverse: true,
                  itemCount: datasnapshot.docs.length,
                  itemBuilder: (context, index) {
                    MessageModel newmessage = MessageModel.fromJson(
                        datasnapshot.docs[index].data()
                            as Map<String, dynamic>);
                    return Row(
                      mainAxisAlignment:
                          (newmessage.sender == widget.chatuser.uid)
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: EdgeInsets.symmetric(
                            vertical: 10,
                            horizontal: 10,
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                              color: (newmessage.sender == widget.chatuser.uid)
                                  ? Color(0xff2865DC)
                                  : Color(0xffFFFFFF),
                              borderRadius: BorderRadius.circular(10),
                              shape: BoxShape.rectangle,
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      (newmessage.sender == widget.chatuser.uid)
                                          ? Color(0xffE4E9F6)
                                          : Color(0xffE1E1E1),
                                  blurRadius: 10,
                                  blurStyle: BlurStyle.normal,
                                  offset: Offset(0, 4),
                                ),
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              (newmessage.msgimg == null &&
                                      newmessage.messagetext
                                          .toString()
                                          .isNotEmpty)
                                  ? Text(
                                      newmessage.messagetext.toString(),
                                      style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: (newmessage.sender ==
                                                widget.chatuser.uid)
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    )
                                  : GestureDetector(
                                      onTap: () {
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) {
                                          return ViewMessagePic(
                                            image: newmessage.msgimg.toString(),
                                          );
                                        }));
                                      },
                                      child: Image.network(
                                        newmessage.msgimg.toString(),
                                        width: 250,
                                        height: 330,
                                      ),
                                    ),
                              SizedBox(
                                height: 5,
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                //crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    DateFormat.jm()
                                        .format(newmessage.timecreated!),
                                    style: GoogleFonts.inter(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w300,
                                      color: (newmessage.sender ==
                                              widget.chatuser.uid)
                                          ? Colors.white
                                          : Colors.black,
                                    ),
                                  ),
                                  (newmessage.sender == widget.chatuser.uid)
                                      ? Icon(
                                          Icons.check,
                                          size: 16,
                                          color: (newmessage.sender ==
                                                  widget.chatuser.uid)
                                              ? Colors.white
                                              : Colors.black,
                                        )
                                      : Text(""),
                                ],
                              )
                            ],
                          ),
                        ),
                      ],
                    );
                  });
            } else if (snapshot.hasError) {
              return Text("Internet Connection Error");
            } else {
              return Text("Say Hi");
            }
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        }));
  }
}
