// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'messagemodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
      messagetext: json['messagetext'] as String?,
      seen: json['seen'] as bool?,
      sender: json['sender'] as String?,
      timecreated: json['timecreated'] == null
          ? null
          : DateTime.parse(json['timecreated'] as String),
      messageid: json['messageid'] as String?,
      msgimg: json['msgimg'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'messageid': instance.messageid,
      'sender': instance.sender,
      'messagetext': instance.messagetext,
      'seen': instance.seen,
      'timecreated': instance.timecreated?.toIso8601String(),
      'msgimg': instance.msgimg,
    };
