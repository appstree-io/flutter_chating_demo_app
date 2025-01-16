import 'package:json_annotation/json_annotation.dart';

part 'notifications.g.dart';

@JsonSerializable()
class NotificationModel {
  String title;
  String body;

  NotificationModel({required this.title, required this.body});

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
