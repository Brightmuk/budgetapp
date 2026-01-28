import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/models/notification_model.dart';

class NotificationService {
  // Singleton pattern for easy access
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('app_icon');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: _onTap,
      // Optional: handles background actions
      onDidReceiveBackgroundNotificationResponse: _onTapBackground,
    );

    // CRITICAL: Handle the case where the app was opened from a closed state
    final launchDetails =
        await _notificationsPlugin.getNotificationAppLaunchDetails();
    if (launchDetails?.didNotificationLaunchApp ?? false) {
      final payload = launchDetails?.notificationResponse?.payload;
      if (payload != null) {
        // Delay slightly to ensure GoRouter is mounted
        Future.delayed(
          const Duration(milliseconds: 500),
          () => _handleNavigation(payload),
        );
      }
    }
    _configureLocalTimeZone();
  }

  Future<void> _configureLocalTimeZone() async {
    if (kIsWeb || Platform.isLinux) {
      return;
    }
    tz.initializeTimeZones();
    if (Platform.isWindows) {
      return;
    }
    final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName!));
  }

  // Unified navigation logic
  void _handleNavigation(String payload) {
    try {
      final notificationPayload = NotificationPayload.fromJson(payload);
      // Navigate using your global router
      router.push(notificationPayload.route, extra: notificationPayload.itemId);
    } catch (e) {
      debugPrint('Notification Navigation Error: $e');
    }
  }

  void _onTap(NotificationResponse details) {
    if (details.payload != null) {
      _handleNavigation(details.payload!);
    }
  }

  static void _onTapBackground(NotificationResponse details) {
    // Background logic (cannot use UI/Router here usually)
  }
  Future<void> showNotification(int id, String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'INSTANCE_CHANNEL',
          'Instance notifications',
          channelDescription: 'Instance notifications channel',
          playSound: true,
          importance: Importance.high,
          priority: Priority.high,
          showWhen: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await _notificationsPlugin.show(id, title, body, platformChannelSpecifics);
  }

  Future<void> zonedScheduleNotification({
    required int id,
    required String title,
    required String description,
    required String payload,
    required tz.TZDateTime scheduling,
  }) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
          'SCHEDULED_CHANNEL',
          'Scheduled notifications',
          channelDescription: 'Scheduled notifications channel',
          importance: Importance.high,
          priority: Priority.high,
          sound: RawResourceAndroidNotificationSound('marimba'),
          showWhen: false,
        );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: DarwinNotificationDetails(sound: 'marimba.aiff'),
    );
    debugPrint('Scheduling notification for $scheduling with id $id');

    // Convert scheduledTime to a timezone-aware datetime
    final tz.TZDateTime scheduledDateTime = tz.TZDateTime.from(
      scheduling,
      tz.local,
    );
    Permission notificationPermission = Permission.notification;
    if (await notificationPermission.isGranted) {
      await _notificationsPlugin.zonedSchedule(
        id,
        title,
        description,
        scheduledDateTime,
        platformChannelSpecifics,
        androidScheduleMode: AndroidScheduleMode.inexact,
        payload: jsonEncode(payload),
      );
    }
  }

  Future<void> cancelReminder(int id) async =>
      await _notificationsPlugin.cancel(id);

  // Foreground Overlay Helper
  void showM3Overlay(String title, String body) {
    showOverlayNotification(
      (context) => SafeArea(
        child: Card(
          margin: const EdgeInsets.all(12),
          color: Theme.of(context).colorScheme.surfaceContainerHigh,
          child: ListTile(
            leading: Icon(
              Icons.notifications_active,
              color: Theme.of(context).colorScheme.primary,
            ),
            title: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(body),
            trailing: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => OverlaySupportEntry.of(context)?.dismiss(),
            ),
          ),
        ),
      ),
      duration: const Duration(seconds: 4),
    );
  }
}
