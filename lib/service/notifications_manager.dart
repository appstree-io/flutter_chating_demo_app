import 'dart:convert';
import 'package:chat_app/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../models/notifications.dart';

class NotificationsManager {
  void init({Function? clickedNotification}) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/app_notification');
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {},
      onDidReceiveBackgroundNotificationResponse: (details) {},
    );

    flutterLocalNotificationsPlugin
        .getNotificationAppLaunchDetails()
        .then((value) {
      print(value);
      if (value!.didNotificationLaunchApp &&
          value.notificationResponse != null) {
        // NotificationObject object =
        //     NotificationObject.fromJson(jsonDecode(value.payload!));
        // clickedNotification!(object);
      }
    });
  }

  void createNotification(Notification? notificationObject) async {
    flutterLocalNotificationsPlugin.show(
      1,
      notificationObject?.title,
      notificationObject?.body,
      NotificationDetails(
        android: AndroidNotificationDetails(
          channel.id,
          channel.name,
          channelDescription: channel.description,
          icon: '@drawable/app_notification',
          styleInformation:
              BigTextStyleInformation(notificationObject?.body ?? ''),
        ),
      ),
      payload: jsonEncode(notificationObject?.toJson()),
    );
  }

  Future selectNotification(String? payload) async {
    if (payload == null) {
      print('notification payload: $payload');
      return;
    }
    // NotificationObject? object =
    //     NotificationObject.fromJson(jsonDecode(payload));
    // preferences?.setString("clicked_noti", payload);
    // Provider.of<GlobalProviderUtils>(context!, listen: false).setNotificationObject(object);
  }
}
