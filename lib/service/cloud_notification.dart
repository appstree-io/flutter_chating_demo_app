import 'dart:developer';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:flutter/foundation.dart';

Future<void> sendNotificationToDevice(String recieverDeviceToken,
    String senderName, String msgBody, String senderImageUrl) async {
  try {
    HttpsCallable callable = FirebaseFunctions.instance
        .httpsCallable('sendMessageNotificationToReciever');
    final result = await callable.call(<String, dynamic>{
      'msg': msgBody,
      'sender': senderName,
      'token': recieverDeviceToken,
      'imageUrl': senderImageUrl,
    });
    final data = result.data;
    log("Cloud Function Result: $data");
  } catch (e) {
    if (kDebugMode) {
      print("Failed to run cloud Function: $e");
    }
  }
}
