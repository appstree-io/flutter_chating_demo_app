import 'package:json_annotation/json_annotation.dart';

part 'usersmodel.g.dart';

@JsonSerializable()
class ChatUser {
 
  String? username;

 
  String? uid;

  
  String? email;

 
  String? phone;

  
  String? profilepic;

  String? about;

  ChatUser({
    this.email,
    this.uid,
    this.profilepic,
    this.username,
    this.phone,
    this.about,
  });

  factory ChatUser.fromJson(Map<String, dynamic> json) =>
      _$ChatUserFromJson(json);
  Map<String, dynamic> toJson() => _$ChatUserToJson(this);
}
