// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/provider/firebase_provider.dart';
import 'package:chat_app/widgets/profile_image_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../provider/firebase_provider.dart';
import 'package:chat_app/models/usersmodel.dart';
import 'package:chat_app/widgets/listview_homepage.dart';

import 'login_page.dart';

class HomePage extends StatefulWidget {
  final ChatUser chatUser;
  final User? firestoreuser;

  const HomePage({
    Key? key,
    required this.chatUser,
    this.firestoreuser,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  void moreOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Options"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {},
                  leading: Icon(Icons.settings),
                  title: Text("Settings"),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  onTap: () async {
                    FirebaseService service = FirebaseService();
                    try {
                      await service.signOutFromGoogle();
                      CircularProgressIndicator(
                        value: 5,
                        backgroundColor: Colors.black,
                        color: Colors.white,
                      );
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => LoginPage()));
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        print(e.message);
                      }
                    }
                  },
                  leading: Icon(Icons.logout_rounded),
                  title: Text("Logout"),
                ),
              ],
            ),
          );
        });
  }

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseService service = FirebaseService();
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {},
        child: Icon(
          Icons.add,
          size: 36,
        ),
        style: ElevatedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(20),
          onPrimary: Color(0xffFFFFFF),
          onSurface: Color(0xff2865DC),
          primary: Color(0xff2865DC),
        ),
      ),
      backgroundColor: Color(0xffFFFFFF),
      appBar: AppBar(
          toolbarHeight: 136,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          title: Padding(
            padding: const EdgeInsets.only(left: 23, top: 23),
            child: SizedBox(
              width: 80,
              height: 80,
              child: CircleAvatar(
                //  radius: 30,
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.circular(40)),
                    child: LogedInUserPic()),
              ),
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.search,
                  size: 36,
                  color: Color(0xff000000),
                ),
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                customBorder: CircleBorder(side: BorderSide(width: 40)),
                onTap: (() {
                  moreOptions();
                }),
                child: Image.asset(
                  "assets/more.png",
                  height: 30,
                  width: 35,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(
              width: 15,
            )
          ]),
      body: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
            padding: const EdgeInsets.only(
              left: 10,
              top: 8,
              right: 5,
              bottom: 10,
            ),
            width: 376,
            height: 65,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xffF3F3F3)),
            child: TabBar(
              controller: _tabController,
              labelColor: Colors.black,
              indicatorColor: Colors.transparent,
              unselectedLabelColor: Color(0xffB7B7B7),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Color(0xffFFFFFF),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff000000).withOpacity(0.3),
                    blurRadius: 18,
                    offset: Offset(2, 8),
                  ),
                ],
              ),
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: [
                Tab(
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      // color: Color(0xffFFFFFF)
                    ),
                    child: Center(
                      child: Text(
                        "Chats",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      // color: Color(0xffFFFFFF),
                    ),
                    child: Center(
                      child: Text(
                        "Stories",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
                Tab(
                  height: 44,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      // color: Color(0xffFFFFFF),
                    ),
                    child: Center(
                      child: Text(
                        "Calls",
                        style: GoogleFonts.inter(
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                ChatList(chatUser: widget.chatUser
                    // (widget.chatUser == null)
                    //     ? widget.chatUser!
                    //     : widget.chatUser!,
                    ),
                Center(
                  child: Text("stories"),
                ),
                Center(
                  child: Text("calls"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
