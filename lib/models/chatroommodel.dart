import 'package:json_annotation/json_annotation.dart';

part 'chatroommodel.g.dart';

@JsonSerializable()
class ChatRoomModel {
  String? chatroomid;

  Map<String, dynamic>? participants;

  String? lastmessage;

  ChatRoomModel({this.chatroomid, this.participants, this.lastmessage});

  factory ChatRoomModel.fromJson(Map<String, dynamic> json) =>
      _$ChatRoomModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatRoomModelToJson(this);
}
