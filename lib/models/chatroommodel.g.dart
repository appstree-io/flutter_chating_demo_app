// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatroommodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatRoomModel _$ChatRoomModelFromJson(Map<String, dynamic> json) =>
    ChatRoomModel(
      chatroomid: json['chatroomid'] as String?,
      participants: json['participants'] as Map<String, dynamic>?,
      lastmessage: json['lastmessage'] as String?,
      time:
          json['time'] == null ? null : DateTime.parse(json['time'] as String),
      lastmsgtime: json['lastmsgtime'] == null
          ? null
          : DateTime.parse(json['lastmsgtime'] as String),
    );

Map<String, dynamic> _$ChatRoomModelToJson(ChatRoomModel instance) =>
    <String, dynamic>{
      'chatroomid': instance.chatroomid,
      'participants': instance.participants,
      'lastmessage': instance.lastmessage,
      'time': instance.time?.toIso8601String(),
      'lastmsgtime': instance.lastmsgtime?.toIso8601String(),
    };
