import 'dart:convert';

import 'package:budgetapp/models/notification_model.dart';
import 'package:budgetapp/navigation/router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:rxdart/subjects.dart';
import 'package:timezone/timezone.dart' as tz;


///Stream to get info about notification while app is in background or foreground
final BehaviorSubject<String?> selectNotificationSubject =
    BehaviorSubject<String?>();

///Stream to get info about notification while app is in background or foreground
final BehaviorSubject<ReceivedNotification> didReceiveLocalNotificationSubject =
    BehaviorSubject<ReceivedNotification>();


class NotificationService {
  
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    init();
  }

  ///Initialise method thats called when the service starts
  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings();

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        selectNotificationSubject.add(details.payload);
      },
    );
    _initNotificationListeners();
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
                importance: Importance.max,
                priority: Priority.high,
                sound: RawResourceAndroidNotificationSound('marimba'),
                channelDescription: 'Reminds you to perform a task')),
        payload: payload,
         androidScheduleMode: AndroidScheduleMode.inexact,
        );
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
            priority: Priority.high,
            importance: Importance.high,
            sound: const RawResourceAndroidNotificationSound('guitar'),
            fullScreenIntent: true,
            styleInformation: const DefaultStyleInformation(true, true));
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(0, 'Time notification',
        'Times out after ${mils! / 1000} seconds', platformChannelSpecifics);
  }

  Future onDidReceiveLocalNotification(
      int? id, String? title, String? body, String? payload) async {
    return Future.value(1);
  }

  Future<void> removeReminder(int notificationId) async {
    flutterLocalNotificationsPlugin.cancel(notificationId);
  }
        void _initNotificationListeners() {
    // Handle background/terminated notification taps
    selectNotificationSubject.stream.listen((String? payload) async {
      if (payload != null) {
        final notificationPayload = NotificationPayload.fromJson(jsonDecode(payload));
        router.go(notificationPayload.route, extra: notificationPayload.itemId);
      }
    });

    // Handle foreground notifications with M3 Overlay
    didReceiveLocalNotificationSubject.stream.listen((ReceivedNotification notification) {
      showOverlayNotification(
        (context) => SafeArea(
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 6,
        color: Theme.of(context).colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).colorScheme.primary,
            child: Icon(Icons.notifications_active, color: Theme.of(context).colorScheme.onPrimary, size: 20),
          ),
          title: Text(notification.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(notification.body ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => OverlaySupportEntry.of(context)?.dismiss(),
          ),
        ),
      ),
    ),
        duration: const Duration(seconds: 4),
      );
    });
  }
}
