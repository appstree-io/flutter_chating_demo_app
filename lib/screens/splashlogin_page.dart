import 'dart:async';

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:flutter/material.dart';

class SplashLoginPage extends StatefulWidget {
  const SplashLoginPage({super.key});

  @override
  State<SplashLoginPage> createState() => _SplashLoginPageState();
}

class _SplashLoginPageState extends State<SplashLoginPage> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: Image.asset("assets/splash-logo.png"),
      nextScreen: LoginPage(),
      duration: 4,
      splashIconSize: 70,
      splashTransition: SplashTransition.fadeTransition,
    );
  }
}
