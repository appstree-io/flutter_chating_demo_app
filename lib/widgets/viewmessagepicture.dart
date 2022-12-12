// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ViewMessagePic extends StatefulWidget {
  final String image;

  const ViewMessagePic({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<ViewMessagePic> createState() => _ViewMessagePicState();
}

class _ViewMessagePicState extends State<ViewMessagePic> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
      ),
      backgroundColor: Colors.black,
      body: Container(
        margin: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Center(
            child: PhotoView(
          imageProvider: NetworkImage(widget.image),
          minScale: PhotoViewComputedScale.contained * 0.8,
          maxScale: PhotoViewComputedScale.covered * 2,
          initialScale: PhotoViewComputedScale.contained * 1.1,
        )
            // child: Image.network(
            //   widget.image,
            // ),
            ),
      ),
    );
  }
}
