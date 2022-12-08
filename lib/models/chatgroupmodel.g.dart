// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chatgroupmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatGroupModel _$ChatGroupModelFromJson(Map<String, dynamic> json) =>
    ChatGroupModel(
      groupid: json['groupid'] as String?,
      participants: json['participants'] as Map<String, dynamic>?,
      lastmessage: json['lastmessage'] as String?,
    );

Map<String, dynamic> _$ChatGroupModelToJson(ChatGroupModel instance) =>
    <String, dynamic>{
      'groupid': instance.groupid,
      'participants': instance.participants,
      'lastmessage': instance.lastmessage,
    };
