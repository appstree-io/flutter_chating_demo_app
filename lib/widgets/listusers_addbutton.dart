// ignore_for_file: public_member_api_docs, sort_constructors_first, use_build_context_synchronously
import 'dart:developer';

import 'package:chat_app/main.dart';
import 'package:chat_app/models/chatgroupmodel.dart';
import 'package:chat_app/models/chatroommodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import 'package:chat_app/models/usersmodel.dart';
import 'package:chat_app/screens/chat_page.dart';
import 'package:uuid/uuid.dart';

class ChatList extends StatefulWidget {
  final User chatUser;

  const ChatList({
    Key? key,
    required this.chatUser,
  }) : super(key: key);

  @override
  State<ChatList> createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  final ChatUser chatuser = ChatUser();
  FirebaseFirestore database = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  late Stream<QuerySnapshot<Map<String, dynamic>>> stream;

  Future<ChatRoomModel?> getChatroomModel(ChatUser targetuser) async {
    ChatRoomModel chatRoom;

    QuerySnapshot chatroomsnapshot = await database
        .collection("Chatrooms")
        .where("participants.${widget.chatUser.uid}", isEqualTo: true)
        .where("participants.${targetuser.uid}", isEqualTo: true)
        .get();

    if (chatroomsnapshot.docs.length > 0) {
      log("Chatroom already exists");
      var docdata = chatroomsnapshot.docs[0].data();
      ChatRoomModel existingchatroom =
          ChatRoomModel.fromJson(docdata as Map<String, dynamic>);

      chatRoom = existingchatroom;
    } else {
      ChatRoomModel newchatroom = ChatRoomModel(
        chatroomid: uuid.v1(),
        lastmessage: "",
        participants: {
          widget.chatUser.uid.toString(): true,
          targetuser.uid.toString(): true,
        },
        time: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection("Chatrooms")
          .doc(newchatroom.chatroomid)
          .set(newchatroom.toJson());
      log("New Chatroom created");

      chatRoom = newchatroom;
    }
    return chatRoom;
  }

  @override
  void initState() {
    final user = _auth.currentUser;
    stream = FirebaseFirestore.instance
        .collection('Users')
        .where("uid", isNotEqualTo: user!.uid)
        .snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final user = _auth.currentUser;
    return StreamBuilder(
        stream: stream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          // snapshot.data.docs[index];
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          QuerySnapshot datasnapshot = snapshot.data as QuerySnapshot;
          if (datasnapshot.docs.length > 0) {
            return ListView.builder(
              itemCount: datasnapshot.docs.length,
              padding: EdgeInsets.symmetric(horizontal: 23, vertical: 40),
              itemBuilder: (context, index) {
                var document = datasnapshot.docs[index];
                Map<String, dynamic> chatuser =
                    datasnapshot.docs[index].data() as Map<String, dynamic>;

                ChatUser addtochatUser = ChatUser.fromJson(chatuser);
                return Padding(
                  padding: const EdgeInsets.only(
                    bottom: 10,
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(document['profilepic']),
                    ),
                    title: Text(document['username']),
                    tileColor: Colors.white,
                    subtitle: Text((document['about'] == null)
                        ? ""
                        : document['about'].toString()),
                    trailing: Icon(Icons.arrow_right),
                    onTap: () async {
                      ChatRoomModel? chatroommodel =
                          await getChatroomModel(addtochatUser);
                      if (chatroommodel != null) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ChatPage(
                              targetuser: addtochatUser,
                              firebaseuser: user!,
                              chatroom: chatroommodel,
                              currentuser: user,
                            ),
                          ),
                        );
                      }
                    },
                  ),
                );
              },
            );
          } else {
            return Text("No Users found");
          }
        });
  }
}
