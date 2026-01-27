import 'dart:convert';

import 'package:budgetapp/models/notification_model.dart';
import 'package:budgetapp/navigation/router.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  // 1. Ensure bindings and services are ready
  WidgetsFlutterBinding.ensureInitialized();
  
  NotificationService().init();
  MobileAds.instance.initialize();
  ScreenUtil.ensureScreenSize();

  // 2. Modern Edge-to-Edge System UI
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  // Fix orientation for better UI consistency
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ApplicationState()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initNotificationListeners();
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
        (context) => _buildM3NotificationOverlay(context, notification),
        duration: const Duration(seconds: 4),
      );
    });
  }

  Widget _buildM3NotificationOverlay(BuildContext context, ReceivedNotification notification) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Card(
        margin: const EdgeInsets.all(12),
        elevation: 6,
        color: theme.colorScheme.surfaceContainerHigh,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: theme.colorScheme.primary,
            child: Icon(Icons.notifications_active, color: theme.colorScheme.onPrimary, size: 20),
          ),
          title: Text(notification.title ?? '', style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text(notification.body ?? '', maxLines: 2, overflow: TextOverflow.ellipsis),
          trailing: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => OverlaySupportEntry.of(context)?.dismiss(),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1080, 2340),
      minTextAdapt: true,
      builder: (context, child) {
        return OverlaySupport.global(
          child: MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Spenditize',
            
            // Material 3 Dark Theme Config
            themeMode: ThemeMode.dark,
            darkTheme: ThemeData(
              useMaterial3: true,
              colorScheme: ColorScheme.fromSeed(
                seedColor: const Color(0xFF48BF84), // Your brand green
                brightness: Brightness.dark,
                primary: const Color(0xFF48BF84),
                surface: const Color(0xFF1A1C1A),
              ),
              // Global component overrides
              appBarTheme: const AppBarTheme(
                centerTitle: false,
                elevation: 0,
                backgroundColor: Colors.transparent,
              ),
              cardTheme: CardThemeData(
                clipBehavior: Clip.antiAlias,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              ),
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}