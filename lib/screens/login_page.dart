// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:developer';

import 'package:chat_app/models/usersmodel.dart';
import 'package:chat_app/provider/firebase_provider.dart';
import 'package:chat_app/screens/signup_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/login_button.dart';
import 'home_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();

  String? _errorMessage;

  void showMessage(String message) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Error"),
            content: Text(message),
            actions: [
              TextButton(
                child: Text("Ok"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }

  void validateEmail(String val) {
    if (val.isEmpty) {
      setState(() {
        _errorMessage = "Email can not be empty";
      });
    } else if (!EmailValidator.validate(val, true)) {
      setState(() {
        _errorMessage = "Invalid Email Address";
      });
    } else {
      setState(() {
        _errorMessage = " ";
      });
    }
  }

  void checkValues() {
    String email = emailcontroller.text.trim();
    String password = passwordcontroller.text.trim();
    if (email == "" || password == "") {
      Fluttertoast.showToast(
        msg: "Email / Password cannot be empty",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } else {
      login(email, password);
    }
  }

  void login(String email, String password) async {
    UserCredential? Credential;
    try {
      Credential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      print(exception.code.toString());
    }

    if (Credential != null) {
      String uid = Credential.user!.uid;
      DocumentSnapshot userData =
          await FirebaseFirestore.instance.collection("Users").doc(uid).get();
      ChatUser loginUser =
          ChatUser.fromJson(userData.data() as Map<String, dynamic>);

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(
                  chatUser: loginUser,
                  firestoreuser: Credential!.user!,
                )),
      );
    } else {
      Fluttertoast.showToast(
        msg: "Email/Password is incorrect",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 50,
          ),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 25,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        width: 60,
                        height: 40,
                      ),
                      SizedBox(width: 8),
                      Image.asset(
                        "assets/ping.png",
                        width: 60,
                        height: 40,
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 45,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    controller: emailcontroller,
                    decoration: const InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                      right: 203,
                      left: 5,
                      bottom: 5,
                      top: 5,
                    ),
                    child: Text(
                      (_errorMessage == null) ? "" : _errorMessage.toString(),
                      style: TextStyle(color: Colors.red),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    textInputAction: TextInputAction.done,
                    controller: passwordcontroller,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  const SizedBox(
                    height: 35,
                  ),
                  LoginButton(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 150,
                    buttoncolor: Color(0xff2865DC),
                    radius: 10,
                    onPressed: () {
                      String val = emailcontroller.text.trim();

                      validateEmail(val);

                      checkValues();
                    },
                    child: Text(
                      "Log in",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  LoginButton(
                    height: 45,
                    width: MediaQuery.of(context).size.width - 150,
                    buttoncolor: Color(0xff2865DC),
                    radius: 10,
                    onPressed: () async {
                      FirebaseService service = FirebaseService();
                      try {
                        await service.signInWithGoogle();
                        CircularProgressIndicator(
                          value: 5,
                          backgroundColor: Colors.black,
                          color: Colors.white,
                        );
                        ChatUser chatUser;
                        chatUser = await service.signInWithGoogle();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => HomePage(
                                      chatUser: chatUser,
                                    )));
                      } catch (e) {
                        if (e is FirebaseAuthException) {
                          print(e.message);
                          log(e.message!);
                          showMessage(e.message!);
                        } else if (e is PlatformException) {
                          print(e.message);
                          log(e.details);
                        }
                      }
                    },
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 8,
                          ),
                          Container(
                            padding: EdgeInsets.all(
                              5,
                            ),
                            height: 38,
                            width: 38,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(25),
                            ),
                            child: Image.asset(
                              "assets/google.png",
                              height: 40,
                              width: 30,
                            ),
                          ),
                          SizedBox(
                            width: 15,
                          ),
                          Text(
                            "Sign in with Google",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              color: Colors.white,
                            ),
                          ),
                        ]),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 30,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Don't have an account? ",
            style: GoogleFonts.poppins(
              fontSize: 16,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const SignupPage()));
            },
            child: Text(
              "Sign up",
              style: GoogleFonts.poppins(
                fontSize: 16,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
