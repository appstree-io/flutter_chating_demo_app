// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chat_app/models/chatroommodel.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:chat_app/service/firebase_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/models/usersmodel.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';

class ChatsHomePage extends StatefulWidget {
  final ChatUser? chatUser;

  const ChatsHomePage({
    Key? key,
    required this.chatUser,
  }) : super(key: key);

  @override
  State<ChatsHomePage> createState() => _ChatsHomePageState();
}

class _ChatsHomePageState extends State<ChatsHomePage> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  @override
  void initState() {
    final user = auth.currentUser;
    stream = FirebaseFirestore.instance
        .collection("Chatrooms")
        .where("participants.${user!.uid}", isEqualTo: true)
        // .orderBy("time", descending: true)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = auth.currentUser;
    return StreamBuilder(
      stream: stream,
      builder: ((context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            QuerySnapshot chatroomsnapshot = snapshot.data as QuerySnapshot;
            return ListView.builder(
              itemCount: chatroomsnapshot.docs.length,
              itemBuilder: ((context, index) {
                ChatRoomModel chatRoomModel = ChatRoomModel.fromJson(
                    chatroomsnapshot.docs[index].data()
                        as Map<String, dynamic>);
                Map<String, dynamic> participants = chatRoomModel.participants!;
                List<String> participantkeys = participants.keys.toList();
                participantkeys.remove(user!.uid);
                return FutureBuilder(
                  future: FirebaseService.getUserModelbyId(participantkeys[0]),
                  builder: (context, userdata) {
                    if (userdata.connectionState == ConnectionState.done) {
                      if (userdata.data != null) {
                        ChatUser targetuser = userdata.data as ChatUser;
                        return Padding(
                          padding: const EdgeInsets.only(
                            top: 5,
                            left: 10,
                            bottom: 5,
                          ),
                          child: ListTile(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: ((context) {
                                    return ChatPage(
                                        targetuser: targetuser,
                                        chatroom: chatRoomModel,
                                        currentuser: user,
                                        firebaseuser: user);
                                  }),
                                ),
                              );
                            },
                            leading: CircleAvatar(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: CachedNetworkImage(
                                  imageUrl: targetuser.profilepic.toString(),
                                  placeholder: (context, url) {
                                    return const Center(
                                      child: SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator()),
                                    );
                                  },
                                  fit: BoxFit.contain,
                                  errorWidget: (context, url, error) {
                                    return Icon(
                                      Icons.error,
                                      //   color: Colors.red,
                                    );
                                  },
                                ),
                              ),
                            ),
                            title: Text(
                              targetuser.username.toString(),
                            ),
                            subtitle: (chatRoomModel.lastmessage!.contains(
                                    'https://firebasestorage.googleapis.com'))
                                ? const Padding(
                                    padding: EdgeInsets.only(
                                      top: 5,
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.image,
                                          size: 20,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Image",
                                        ),
                                        SizedBox(
                                          width: 40,
                                        ),
                                        Text(""),
                                      ],
                                    ))
                                : Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        chatRoomModel.lastmessage.toString(),
                                      ),
                                      Text(
                                        (chatRoomModel.lastmsgtime == null)
                                            ? ""
                                            : DateFormat.jm().format(
                                                chatRoomModel.lastmsgtime!),
                                      ),
                                    ],
                                  ),
                            trailing: Image.asset(
                              "assets/right.png",
                              scale: 3.5,
                            ),
                          ),
                        );
                      } else {
                        return const Text("User data is null");
                      }
                    } else {
                      return Center(child: SizedBox());
                    }
                  },
                );
              }),
            );
          } else if (snapshot.hasError) {
            return Text(snapshot.error.toString());
          } else {
            return const Center(
              child: Text("No Chat found"),
            );
          }
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          return const Center(child: Text("Error: Check Internet Connection"));
        }
      }),
    );
  }
}
