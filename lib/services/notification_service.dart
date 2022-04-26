import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'dart:developer';

final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

class NotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    init();
  }

  Future<void> init() async {
    var initializationSettingsAndroid =
        const AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  ///Schedule a notification to a certain time or date
  Future<void> zonedScheduleNotification(
      {int? id,
      String? title,
      String? description,
      String? payload,
      tz.TZDateTime? scheduling}) async {
    await flutterLocalNotificationsPlugin.zonedSchedule(
        id!,
        title,
        description,
        scheduling!,
        const NotificationDetails(
            android: AndroidNotificationDetails('1', 'Reminders',
                importance: Importance.high,
                channelDescription: 'Reminds you to perform a task')),
        payload: payload,
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  ///Remove a reminder
  Future<void> cancelReminder(int id) async {
    await flutterLocalNotificationsPlugin.cancel(id);

  }

  ///A notification that dissapears after the set timeout
  Future<void> showTimeoutNotification(int? mils) async {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('0', 'Popup',
            channelDescription: 'Short reminder',
            timeoutAfter: mils,
            styleInformation: const DefaultStyleInformation(true, true));
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Timeout notification',
        'Times out after ${mils! / 1000} seconds', platformChannelSpecifics);
  }

  Future<void> onSelectNotification(String? payload) async {
    // selectNotificationSubject.add()
    // Navigator.pushNamed(context, message.data['screen'],
    //         arguments: routeArguments(message.data['screen'], message.data));
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    return Future.value(1);
  }

  Future<void> removeReminder(int notificationId)async {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }
}
