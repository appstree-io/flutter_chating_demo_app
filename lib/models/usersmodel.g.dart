// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'usersmodel.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatUser _$ChatUserFromJson(Map<String, dynamic> json) => ChatUser(
      email: json['email'] as String?,
      uid: json['uid'] as String?,
      profilepic: json['profilepic'] as String?,
      username: json['username'] as String?,
      phone: json['phone'] as String?,
      about: json['about'] as String?,
    );

Map<String, dynamic> _$ChatUserToJson(ChatUser instance) => <String, dynamic>{
      'username': instance.username,
      'uid': instance.uid,
      'email': instance.email,
      'phone': instance.phone,
      'profilepic': instance.profilepic,
      'about': instance.about,
    };
