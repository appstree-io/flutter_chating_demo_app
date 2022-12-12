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
      messageimage: _$JsonConverterFromJson<String, XFile?>(
          json['messageimage'], const XFileConverter().fromJson),
      msgimg: json['msgimg'] as String?,
    );

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'messageid': instance.messageid,
      'sender': instance.sender,
      'messagetext': instance.messagetext,
      'messageimage': const XFileConverter().toJson(instance.messageimage),
      'seen': instance.seen,
      'timecreated': instance.timecreated?.toIso8601String(),
      'msgimg': instance.msgimg,
    };

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) =>
    json == null ? null : fromJson(json as Json);
