import 'package:chat_app/models/usersmodel.dart';
import 'package:chat_app/screens/complete_profile_page.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/login_button.dart';
import 'login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  TextEditingController emailcontroller = TextEditingController();
  TextEditingController phonecontroller = TextEditingController();
  TextEditingController passwordcontroller = TextEditingController();
  TextEditingController cnfrmpasscontroller = TextEditingController();

  String _errorMessage = "";

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
        _errorMessage = "";
      });
    }
  }

  void checkValues() {
    String email = emailcontroller.text.trim();
    String phone = phonecontroller.text.trim();
    String password = passwordcontroller.text.trim();
    String cnfrmpass = cnfrmpasscontroller.text.trim();

    if (phone == "" || password == "" || cnfrmpass == "" || email == "") {
      Fluttertoast.showToast(
        msg: "Please Fill all fields!!!",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } else if (password != cnfrmpass) {
      Fluttertoast.showToast(
        msg: "Passwords do not match!!!",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } else {
      signup(email, password, phone);
    }
  }

  void signup(String email, String password, String phone) async {
    UserCredential? credential;

    try {
      credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (exception) {
      Fluttertoast.showToast(
        msg: "Email already exists",
        backgroundColor: Colors.black,
        textColor: Colors.white,
      );
    } on FirebaseAuthException catch (exception) {
      print(exception.code);
    }

    if (credential != null) {
      String uid = credential.user!.uid;
      ChatUser newUser = ChatUser(
        uid: uid,
        email: email,
        username: "",
        profilepic: "",
        phone: phone,
      );
      await FirebaseFirestore.instance
          .collection("Users")
          .doc(uid)
          .set(newUser.toJson())
          .then((value) {
        Navigator.push(context, MaterialPageRoute(builder: ((context) {
          return CompleteProfile(
            chatUser: newUser,
            firestoreuser: credential!.user!,
          );
        })));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: BackButton(color: Colors.black),
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 35),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
                controller: emailcontroller,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
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
                  _errorMessage.toString(),
                  style: TextStyle(color: Colors.red),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.number,
                controller: phonecontroller,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: "Phone No",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                controller: passwordcontroller,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Password",
                ),
              ),
              const SizedBox(
                height: 10,
              ),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                controller: cnfrmpasscontroller,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: "Confirm Password",
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              LoginButton(
                height: 45,
                width: MediaQuery.of(context).size.width - 150,
                buttoncolor: Color(0xff2865DC),
                radius: 10,
                onPressed: () {
                  checkValues();
                },
                child: Text(
                  "Sign up",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(
                height: 15,
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.only(
          bottom: 30,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            "Already have an account? ",
            style: GoogleFonts.poppins(
              fontSize: 15,
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LoginPage()));
            },
            child: Text(
              "Sign in",
              style: GoogleFonts.poppins(
                fontSize: 15,
              ),
            ),
          )
        ]),
      ),
    );
  }
}
