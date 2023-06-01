// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:chat_app/screens/selectusertochat_page.dart';
import 'package:chat_app/screens/Profile_Screens/userinfo_page.dart';
import 'package:chat_app/service/firebase_messaging_manger.dart';
import 'package:chat_app/service/firebase_service.dart';
import 'package:chat_app/widgets/chats_homepage.dart';
import 'package:chat_app/widgets/profile_image_homepage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:google_fonts/google_fonts.dart';
import '../service/firebase_service.dart';
import 'package:chat_app/models/usersmodel.dart';
import 'package:chat_app/widgets/listusers_addbutton.dart';

import 'Login_Screens/login_page.dart';

class HomePage extends StatefulWidget {
  final ChatUser? chatUser;
  final User? firestoreuser;

  const HomePage({
    Key? key,
    this.chatUser,
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
    _tabController = TabController(
      length: 3,
      vsync: this,
      // animationDuration: const Duration(milliseconds: 1),
    );
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      FirebaseMessagingManager firebaseMessagingManager =
          FirebaseMessagingManager(context);
      firebaseMessagingManager.init(user!);
    });
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    debugPrint(widget.chatUser?.username ?? '');
  }

  void moreOptions() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black,
            title: Text(
              "Options",
              style: GoogleFonts.inter(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  onTap: () {},
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Settings",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 15,
                ),
                ListTile(
                  onTap: () async {
                    FirebaseService service = FirebaseService();
                    try {
                      await service.signOutFromGoogle();
                      EasyLoading.showToast(
                        "Logged Out",
                        toastPosition: EasyLoadingToastPosition.bottom,
                        duration: const Duration(
                          seconds: 1,
                        ),
                      );

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()));
                    } catch (e) {
                      if (e is FirebaseAuthException) {
                        print(e.message);
                      }
                    }
                  },
                  leading: const Icon(
                    Icons.logout_rounded,
                    color: Colors.white,
                  ),
                  title: Text(
                    "Logout",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }

  User? user = FirebaseAuth.instance.currentUser;
  FirebaseService service = FirebaseService();
  // final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: ((context) {
                return SelectUserToChat(chatUser: user);
              }),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          foregroundColor: const Color(0xffFFFFFF),
          backgroundColor: const Color(0xff2865DC),
          shape: const CircleBorder(),
          disabledForegroundColor: const Color(0xff2865DC).withOpacity(0.38),
          disabledBackgroundColor: const Color(0xff2865DC).withOpacity(0.12),
          padding: const EdgeInsets.all(20),
        ),
        child: const Icon(
          Icons.add,
          size: 36,
        ),
      ),
      backgroundColor: const Color(0xffFFFFFF),
      appBar: AppBar(
          toolbarHeight: 136,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          automaticallyImplyLeading: false,
          leadingWidth: 90,
          leading: Padding(
            padding: const EdgeInsets.only(left: 30, top: 23),
            child: InkWell(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: ((context) {
                      return UserInfoPage(
                        chatUser: user!,
                      );
                    }),
                  ),
                );
                debugPrint(user?.uid ?? '');
              },
              child: const LogedInUserPic(),
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
            const SizedBox(
              width: 10,
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 30,
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(30),
                customBorder: const CircleBorder(side: BorderSide(width: 40)),
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
              unselectedLabelColor: const Color(0xffB7B7B7),
              indicator: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: const Color(0xffFFFFFF),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xff000000).withOpacity(0.3),
                    blurRadius: 18,
                    offset: const Offset(2, 8),
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
                ChatsHomePage(chatUser: widget.chatUser),
                const Center(
                  child: Text("stories"),
                ),
                const Center(
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
