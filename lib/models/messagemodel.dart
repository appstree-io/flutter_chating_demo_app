import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'messagemodel.g.dart';

@JsonSerializable()
class MessageModel {
  String? messageid;

  String? sender;

  String? messagetext;

  bool? seen;

  DateTime? timecreated;

  String? msgimg;

  MessageModel({
    this.messagetext,
    this.seen,
    this.sender,
    this.timecreated,
    this.messageid,
    this.msgimg,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) =>
      _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);
}

// class XFileConverter extends JsonConverter<XFile?, String> {
//   const XFileConverter();

//   @override
//   XFile fromJson(String json) => XFile(json);

//   @override
//   String toJson(XFile? object) => object.path;
// }
