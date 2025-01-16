import 'dart:async';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/provider/user_provider.dart';
import 'package:chat_app/screens/Login_Screens/login_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/service/firebase_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SplashPageHome extends StatefulWidget {
  bool toLoginScreen;
  SplashPageHome({super.key, required this.toLoginScreen});

  @override
  State<SplashPageHome> createState() => _SplashPageHomeState();
}

class _SplashPageHomeState extends State<SplashPageHome> {
  UserProvider? _userProvider;
  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _userProvider = Provider.of<UserProvider>(context);
  }

  void getCurrentUser() async {
    var user = FirebaseAuth.instance.currentUser;
    FirebaseService firebaseService = FirebaseService();
    if (user != null) {
      var chatUser = await firebaseService.getCurrentUser(user.uid);
      _userProvider!.setChatUser(chatUser!);
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset("assets/splash-logo.png"),
      nextScreen: (widget.toLoginScreen)
          ? const LoginPage()
          : HomePage(
              userProvider: _userProvider,
            ),
      duration: 5,
      splashIconSize: 70,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
