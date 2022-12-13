// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';
import 'dart:io';
import 'package:chat_app/widgets/about_userdata.dart';
import 'package:chat_app/widgets/email_userdata.dart';
import 'package:chat_app/widgets/name_userdata.dart';
import 'package:chat_app/widgets/phone_userdata.dart';
import 'package:chat_app/widgets/profile_image_homepage.dart';
import 'package:chat_app/widgets/userinfo_popup.dart';
import 'package:chat_app/widgets/viewuserprofilepic.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

class UserInfoPage extends StatefulWidget {
  final User chatUser;

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
  TextEditingController phonecontroller = TextEditingController();

  String? fullname;
  String? aboutprofile;
  String? phonenumber;
  File? imagefile;

  void imageSelect(ImageSource source) async {
    XFile? pickedimage = await ImagePicker().pickImage(source: source);
    if (pickedimage != null) {
      cropImage(pickedimage);
    }
  }

  void cropImage(XFile file) async {
    CroppedFile? cropedImage = (await ImageCropper().cropImage(
      sourcePath: file.path,
      compressQuality: 20,
      aspectRatio: CropAspectRatio(ratioX: 1, ratioY: 1),
    ));

    if (cropedImage != null) {
      setState(() {
        imagefile = File(cropedImage.path);
      });
      UpdateProfileImage();
    }
  }

  void UpdateProfileImage() async {
    UploadTask uploadTask = FirebaseStorage.instance
        .ref("profilepics")
        .child(widget.chatUser.uid.toString())
        .putFile(imagefile!);

    TaskSnapshot snapshot = await uploadTask;

    String? imgUrl = await snapshot.ref.getDownloadURL();

    final String image = imgUrl;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.chatUser.uid.toString())
        .update({"profilepic": image});
  }

  void UpdateProfileName() async {
    final String username = namecontroller.text;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.chatUser.uid.toString())
        .update({"username": username});
  }

  void UpdateProfileAbout() async {
    log("In profile About");
    log(aboutcontroller.text);
    log(aboutprofile.toString());

    final String about = aboutcontroller.text;

    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.chatUser.uid)
        .update({"about": about});
    log("About updated");
  }

  void UpdateProfilePhone() async {
    final String phone = phonecontroller.text;
    await FirebaseFirestore.instance
        .collection("Users")
        .doc(widget.chatUser.uid.toString())
        .update({"phone": phone});
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: const Color(0xffFFFFFF),
        appBar: AppBar(
          backgroundColor: const Color(0xff2865DC),
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
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      fit: StackFit.loose,
                      children: [
                        InkWell(
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: ((context) {
                              return ViewUserProfilePic();
                            })));
                          },
                          child: CircleAvatar(
                            radius: 70,
                            // backgroundImage: NetworkImage(
                            //   widget.chatUser.profilepic.toString(),
                            // ),
                            child: LogedInUserPic(),
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            imageSelect(ImageSource.gallery);
                          },
                          child: Container(
                              height: 45,
                              width: 45,
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Color(0xff2865DC),
                                shape: BoxShape.circle,
                              ),
                              child: Image.asset(
                                "assets/camera.png",
                                //scale: 0.2,
                              )),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  ListTile(
                    //isThreeLine: true,
                    iconColor: Colors.black,
                    leading: const Icon(Icons.person),
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
                        const SizedBox(
                          height: 5,
                        ),
                        UserName(),
                      ],
                    ),
                    onTap: () async {
                      UserInfoPop popupname = UserInfoPop(
                        context: context,
                        textcontroller: namecontroller,
                        keyboardtype: TextInputType.name,
                        title: const Text("Full Name"),
                        hinttext: "Name",
                        maxlength: 14,
                        updatedata: () {
                          log("In update data");
                          UpdateProfileName();
                        },
                        onSubmitingcomplete: (name) {
                          UpdateProfileName();
                          Navigator.of(context).pop();
                        },
                      );
                      final name = await popupname.popup();
                      if (name == null || name.isEmpty) {}
                      setState(() {
                        fullname = name;
                        print(fullname);
                      });
                      print(fullname);
                    },
                    trailing: IconButton(
                      onPressed: () {},
                      icon: const Icon(
                        Icons.edit,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 5,
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    onTap: () async {
                      UserInfoPop popupabout = UserInfoPop(
                        updatedata: () {
                          log("In update data");
                          UpdateProfileAbout();
                        },
                        context: context,
                        textcontroller: aboutcontroller,
                        keyboardtype: TextInputType.text,
                        title: const Text(
                          "About",
                        ),
                        hinttext: "About",
                        maxlength: 130,
                        onSubmitingcomplete: (about) {
                          log("In editing complete");
                          UpdateProfileAbout();
                          Navigator.of(context).pop();
                        },
                      );
                      final about = await popupabout.popup();
                      log("about after calling popup");
                      if (about == null || about.isEmpty) {
                        // print(about);
                      } else {
                        log("In Setstate");
                        setState(() {
                          aboutprofile = about;
                          // print(aboutprofile);
                        });
                      }
                      log(aboutprofile.toString());
                      log("Afterset state");
                    },
                    iconColor: Colors.black,
                    leading: const Icon(
                      Icons.info,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 3,
                        ),
                        UserAbout()
                      ],
                    ),
                    trailing: const Icon(
                      Icons.edit,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    onTap: () async {
                      UserInfoPop popupphone = UserInfoPop(
                        context: context,
                        updatedata: () {
                          UpdateProfileName();
                        },
                        textcontroller: phonecontroller,
                        keyboardtype: TextInputType.name,
                        title: const Text("Phone Number"),
                        hinttext: "Phone",
                        maxlength: 15,
                        onSubmitingcomplete: (phone) {
                          UpdateProfilePhone();
                        },
                      );
                      final phone = await popupphone.popup();
                      if (phone == null || phone.isEmpty) {
                        print(phone);
                      }
                      setState(() {
                        phonenumber = phone;
                      });
                      print(phonenumber);
                    },
                    iconColor: Colors.black,
                    leading: const Icon(Icons.phone_iphone),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Phone Number",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        UserPhone(),
                      ],
                    ),
                    trailing: const Icon(
                      Icons.edit,
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
                  ),
                  ListTile(
                    leading: Icon(
                      Icons.email,
                      color: Colors.black,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: GoogleFonts.inter(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        UserEmail(),
                      ],
                    ),
                  ),
                  const Divider(),
                  const SizedBox(
                    height: 5,
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
