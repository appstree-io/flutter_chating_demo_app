// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';

part 'chatroommodel.g.dart';

@JsonSerializable()
class ChatRoomModel {
  String? chatroomid;

  Map<String, dynamic>? participants;

  String? lastmessage;

  DateTime? time;

  DateTime? lastmsgtime;

  ChatRoomModel({
    this.chatroomid,
    this.participants,
    this.lastmessage,
    this.time,
    this.lastmsgtime,
  });

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);
}
