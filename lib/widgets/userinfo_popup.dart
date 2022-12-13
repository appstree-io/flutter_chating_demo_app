// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class UserInfoPop {
  BuildContext context;
  TextEditingController textcontroller;
  Widget title;
  int maxlength;
  void Function(String)? onSubmitingcomplete;
  String hinttext;
  TextInputType keyboardtype;
  VoidCallback updatedata;

  UserInfoPop({
    required this.context,
    required this.textcontroller,
    required this.title,
    required this.maxlength,
    required this.onSubmitingcomplete,
    required this.hinttext,
    required this.keyboardtype,
    required this.updatedata,
  });

  Future<String?> popup() {
    return showDialog<String>(
      context: context,
      builder: ((context) {
        return AlertDialog(
          title: title,
          content: TextField(
            autofocus: true,
            controller: textcontroller,
            maxLength: maxlength,
            keyboardType: keyboardtype,
            textInputAction: TextInputAction.done,
            onSubmitted: onSubmitingcomplete,
            decoration: InputDecoration(
              hintText: hinttext,
            ),
          ),
          actions: [
            // TextButton(
            //   onPressed: () {
            //     updatedata;
            //     Navigator.of(context).pop(textcontroller.text.trim());
            //     textcontroller.clear();
            //   },
            //   child: Text(
            //     "Save",
            //     style: GoogleFonts.acme(color: Colors.cyan),
            //   ),
            // )
          ],
        );
      }),
    );
  }
}
