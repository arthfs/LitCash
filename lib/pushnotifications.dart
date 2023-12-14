//import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LocalNotification {
  static final FlutterLocalNotificationsPlugin localNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static void initialize() async {
    final InitializationSettings initializationSettingsAndroid =
        InitializationSettings(
            android: AndroidInitializationSettings('ic_launcher'));
    localNotificationsPlugin.initialize(
      initializationSettingsAndroid,
    );
  }

  static void show(RemoteMessage message) async {
    try {
      final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;
      const NotificationDetails notificationdetails = NotificationDetails(
          android: AndroidNotificationDetails(
        'mychanel',
        'asdf',
        //playSound: true,
        enableVibration: true,
        ledColor: Colors.cyan,
        ledOffMs: 5,
        ledOnMs: 5,
        enableLights: true,
        priority: Priority.high,
        importance: Importance.max,
      ));

      await localNotificationsPlugin.show(
        id,
        message.notification!.title,
        message.notification!.body,
        notificationdetails,
      );
/*
    final detroit = tz.getLocation('America/Detroit');
    var programmed = DateTime(2022, 7, 2, DateTime.now().hour,
        DateTime.now().minute, DateTime.now().second + 5);
    var b = tz.TZDateTime.fromMillisecondsSinceEpoch(
        detroit, programmed.microsecondsSinceEpoch);
    await localNotificationsPlugin.zonedSchedule(
        12, 'title', 'body', b, platformChannelSpecifics,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidAllowWhileIdle: true);
  */
    } on Exception catch (e) {
      print(e);
    }
  }

  void onDidReceiveLocalNotification(a, b, c, d) {}
  //LocalNotification._internal();
}
