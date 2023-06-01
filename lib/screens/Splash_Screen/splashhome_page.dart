import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/screens/Login_Screens/login_page.dart';
import 'package:chat_app/screens/home_page.dart';
import 'package:flutter/material.dart';

class SplashPageHome extends StatefulWidget {
  bool toLoginScreen;
  SplashPageHome({super.key, required this.toLoginScreen});

  @override
  State<SplashPageHome> createState() => _SplashPageHomeState();
}

class _SplashPageHomeState extends State<SplashPageHome> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset("assets/splash-logo.png"),
      nextScreen: (widget.toLoginScreen) ? const LoginPage() : const HomePage(),
      duration: 4,
      splashIconSize: 70,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
