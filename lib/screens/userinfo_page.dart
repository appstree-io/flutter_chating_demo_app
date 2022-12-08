// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/usersmodel.dart';

class UserInfoPage extends StatefulWidget {
  final ChatUser chatUser;

  const UserInfoPage({
    Key? key,
    required this.chatUser,
  }) : super(key: key);

  @override
  State<UserInfoPage> createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController namecontroller = TextEditingController();
  TextEditingController aboutcontroller = TextEditingController();
  bool _isEnabled = false;
  bool _isEnabledabout = false;
  bool _isEnabledphone = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: Color(0xff2865DC),
          toolbarHeight: 120,
          title: Text(
            "Profile",
            style: GoogleFonts.inter(
              fontSize: 24,
            ),
          ),
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(
                top: 20,
                right: 20,
                left: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: CircleAvatar(
                      radius: 65,
                      backgroundImage: NetworkImage(
                        widget.chatUser.profilepic.toString(),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    isThreeLine: true,
                    iconColor: Colors.black,
                    leading: Icon(Icons.person),
                    title: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Full Name",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(widget.chatUser.username.toString()),
                      ],
                    ),
                    subtitle: TextField(
                      controller: namecontroller,
                      //enabled: _isEnabled,
                      maxLength: 20,
                      textInputAction: TextInputAction.done,
                      onEditingComplete: () {
                        _isEnabled = !_isEnabled;
                      },
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabled: _isEnabled,
                        hintText: "Change your app username",
                      ),
                    ),
                    onTap: () {
                      setState(() {
                        _isEnabled = !_isEnabled;
                      });
                    },
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        _isEnabledabout = !_isEnabledabout;
                      });
                    },
                    iconColor: Colors.black,
                    leading: Icon(
                      Icons.info,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("About"),
                        SizedBox(
                          height: 3,
                        ),
                        Text(widget.chatUser.about.toString()),
                      ],
                    ),
                    subtitle: TextField(
                      controller: aboutcontroller,
                      maxLength: 40,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        enabled: _isEnabledabout,
                      ),
                    ),
                    trailing: Icon(
                      Icons.edit,
                    ),
                  ),
                  Divider(),
                  SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    onTap: () {
                      setState(() {
                        _isEnabledphone = !_isEnabledphone;
                      });
                    },
                    iconColor: Colors.black,
                    leading: Icon(Icons.phone_android),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Phone Number"),
                        SizedBox(
                          height: 5,
                        ),
                        Text(widget.chatUser.phone.toString()),
                      ],
                    ),
                    subtitle: TextField(
                      decoration: InputDecoration(
                          enabled: _isEnabled, border: InputBorder.none),
                    ),
                    trailing: Icon(
                      Icons.edit,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
