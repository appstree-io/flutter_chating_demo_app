import 'package:chat_app/screens/Profile_Screens/complete_profile_phonelogin_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../models/usersmodel.dart';

class PhoneLogin extends StatefulWidget {
  const PhoneLogin({super.key});

  @override
  State<PhoneLogin> createState() => _PhoneLoginState();
}

class _PhoneLoginState extends State<PhoneLogin> {
  TextEditingController phoneController = TextEditingController();
  String? phoneNumber, verificationId;
  String? otp, authStatus = "";
  User? user = FirebaseAuth.instance.currentUser;

  Future<void> verifyPhoneNumber(BuildContext context) async {
    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      timeout: const Duration(seconds: 15),
      verificationCompleted: (AuthCredential authCredential) {
        setState(() {
          authStatus = "Your account is successfully verified";
        });
      },
      verificationFailed: (FirebaseAuthException authException) {
        setState(() {
          authStatus = "Authentication failed";
        });
      },
      codeSent: (String verId, [int? forceCodeResent]) {
        verificationId = verId;
        setState(() {
          authStatus = "OTP has been successfully send";
        });
        otpDialogBox(context).then((value) {});
      },
      codeAutoRetrievalTimeout: (String verId) {
        verificationId = verId;
        setState(() {
          authStatus = "TIMEOUT";
        });
      },
    );
  }

  otpDialogBox(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Enter your OTP'),
            content: Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(
                      Radius.circular(30),
                    ),
                  ),
                ),
                onChanged: (value) {
                  otp = value;
                },
              ),
            ),
            contentPadding: EdgeInsets.all(10.0),
            actions: <Widget>[
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  if (otp == "") {
                    Fluttertoast.showToast(
                        msg: "OTP cannot be empty",
                        backgroundColor: Colors.black);
                  } else {
                    signIn(otp);
                  }
                },
                child: const Text(
                  'Submit',
                ),
              ),
            ],
          );
        });
  }

  Future<void> signIn(String? otp) async {
    UserCredential? credential;
    try {
      credential = await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(
          verificationId: verificationId!,
          smsCode: otp!,
        ),
      );
    } on FirebaseAuthException catch (exception) {
      Fluttertoast.showToast(
        msg: exception.code.toString(),
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
    if (credential != null) {
      String uid = credential.user!.uid;
      final docRef = FirebaseFirestore.instance.collection("Users").doc(uid);
      docRef.get().then(
        (DocumentSnapshot doc) async {
          if (doc.exists == false) {
            ChatUser newUser = ChatUser(
              uid: uid,
              email: "",
              username: "",
              profilepic: "",
              phone: phoneNumber,
            );
            await FirebaseFirestore.instance
                .collection("Users")
                .doc(uid)
                .set(newUser.toJson())
                .then((value) {
              Fluttertoast.showToast(
                msg: "Account Created Succesfully",
                backgroundColor: Colors.black,
                textColor: Colors.white,
              );
              Navigator.push(context, MaterialPageRoute(builder: ((context) {
                return CompleteProfilePhone(
                  chatUser: newUser,
                  firestoreuser: credential!.user!,
                );
              })));
            });
          } else {
            Navigator.push(context, MaterialPageRoute(builder: ((context) {
              return HomePage();
            })));
          }
        },
        onError: (e) => print("Error getting document: $e"),
      );
      // if(docRef.snapshots().isEmpty == true){

      // }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: const BackButton(
            color: Colors.black,
          ),
          elevation: 0,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 30,
            vertical: 40,
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Image.asset(
                    "assets/splash-logo.png",
                    width: MediaQuery.of(context).size.width * 0.4,
                  ),
                ),
                const SizedBox(
                  height: 80,
                ),
                Text(
                  "Log in with Phone",
                  style: GoogleFonts.inter(
                    color: Colors.black,
                    fontSize: 22,
                  ),
                ),
                const SizedBox(
                  height: 35,
                ),
                TextFormField(
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.done,
                  controller: phoneController,
                  decoration: const InputDecoration(
                    labelText: "Phone Number",
                    hintText: "For e.g +923xxxxxxxxx",
                  ),
                  onChanged: (value) {
                    phoneNumber = value;
                  },
                ),
                const SizedBox(
                  height: 35,
                ),
                Center(
                  child: LoginButton(
                    height: 45,
                    onPressed: () {
                      verifyPhoneNumber(context);
                    },
                    width: MediaQuery.of(context).size.width - 150,
                    child: Text(
                      "Send OTP",
                      style: GoogleFonts.inter(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    buttoncolor: Color(0xff2958DC),
                    radius: 24,
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  (authStatus == "") ? "" : authStatus!,
                  style: TextStyle(
                      color: authStatus!.contains("fail") ||
                              authStatus!.contains("TIMEOUT")
                          ? Colors.red
                          : Colors.green),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
