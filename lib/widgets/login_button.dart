import 'package:flutter/material.dart';

class LoginButton extends StatelessWidget {
  double height;
  double width;
  Widget child;
  Color buttoncolor;
  double radius;
  VoidCallback? onPressed;
  LoginButton({
    Key? key,
    required this.height,
    required this.width,
    required this.child,
    required this.buttoncolor,
    required this.radius,
    this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Container(
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: buttoncolor, borderRadius: BorderRadius.circular(radius)),
        child: Center(child: child),
      ),
    );
  }
}
