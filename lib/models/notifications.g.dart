// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notifications.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationModel _$NotificationFromJson(Map<String, dynamic> json) =>
    NotificationModel(
      title: json['title'] as String,
      body: json['body'] as String,
    );

Map<String, dynamic> _$NotificationToJson(NotificationModel instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };
