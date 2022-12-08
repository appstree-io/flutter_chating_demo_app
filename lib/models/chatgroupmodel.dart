import 'package:json_annotation/json_annotation.dart';

part 'chatgroupmodel.g.dart';

@JsonSerializable()
class ChatGroupModel {
  String? groupid;

  Map<String, dynamic>? participants;

  String? lastmessage;

  ChatGroupModel({this.groupid, this.participants, this.lastmessage});

  factory ChatGroupModel.fromJson(Map<String, dynamic> json) =>
      _$ChatGroupModelFromJson(json);
  Map<String, dynamic> toJson() => _$ChatGroupModelToJson(this);
}
