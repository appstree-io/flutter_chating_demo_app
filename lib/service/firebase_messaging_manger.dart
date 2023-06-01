import 'package:chat_app/screens/home_page.dart';
import 'package:chat_app/service/firebase_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/notifications.dart' as model;
import 'notifications_manager.dart';

class FirebaseMessagingManager {
  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseService firebaseService = FirebaseService();
  final BuildContext context;

  FirebaseMessagingManager(this.context);

  void init(User user) {
    _firebaseMessaging = FirebaseMessaging.instance;
    _firebaseMessaging?.getToken().then((value) {
      print("FCM Token = $value");
      String deviceToken = value!;
      if (user.uid.isNotEmpty) {
        firebaseService.updateUserToken(deviceToken, user.uid);
      }
    });
    _firebaseMessaging?.onTokenRefresh.listen(
      (value) {
        String deviceToken = value;
        if (user.uid.isNotEmpty) {
          firebaseService.updateUserToken(deviceToken, user.uid);
        }
      },
    );

    // FirebaseMessaging.onMessageOpenedApp.listen((event) async {
    //   print('Messaging event $event');
    //   Navigator.push(
    //     context,
    //     MaterialPageRoute(
    //       builder: (context) {
    //         return HomePage();
    //       },
    //     ),
    //   );
    // });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Got a message whilst in the foreground!');
      print('Message : $message');
      print('Message title: ${message.notification!.title}');
      print('Message data: ${message.data}');

      var noti = model.Notification(
        title: message.notification?.title ?? '',
        body: message.notification?.body ?? '',
      );
      NotificationsManager().createNotification(noti);
    });

    // FirebaseMessaging.onBackgroundMessage((message) {
    //   return _backgroundMessageHandler(message);
    // });
  }

  // Future<void> _backgroundMessageHandler(RemoteMessage message) async {
  //   var noti = model.Notification(
  //     title: message.notification?.title ?? '',
  //     body: message.notification?.body ?? '',
  //   );
  //   NotificationsManager().createNotification(noti);
  // }
}
