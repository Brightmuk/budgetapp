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
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  setUp();
  MobileAds.instance.initialize();
  await ScreenUtil.ensureScreenSize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 233, 213, 213),
      statusBarBrightness: Brightness.dark));

  runApp(MultiProvider(providers: [
    ChangeNotifierProvider<ApplicationState>.value(value: ApplicationState())
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _configureSelectNotificationSubject();
    configureDidReceiveLocalNotificationSubject();
  }

  void _configureSelectNotificationSubject() {
    selectNotificationSubject.stream.listen((String? payload) async {
      if (payload != null) {
        final notificationPayload =
            NotificationPayload.fromJson(jsonDecode(payload));
        router.go(
          notificationPayload.route,
          extra: notificationPayload.itemId,
        );
      }
    });
  }

  void configureDidReceiveLocalNotificationSubject() {
    didReceiveLocalNotificationSubject.stream
        .listen((ReceivedNotification receivedNotification) async {
      showOverlayNotification(
        (context) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            child: SafeArea(
              child: ListTile(
                leading: SizedBox.fromSize(
                  size: const Size(40, 40),
                  child: ClipOval(
                    child: Container(
                      color: Colors.black,
                    ),
                  ),
                ),
                title: Text(receivedNotification.title ?? ''),
                subtitle: Text(receivedNotification.body ?? ''),
                trailing: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () {
                    OverlaySupportEntry.of(context)!.dismiss();
                  },
                ),
              ),
            ),
          );
        },
        duration: const Duration(seconds: 4),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 2340),
        builder: (context, child) {
          return OverlaySupport.global(
            child: MaterialApp.router(
              debugShowCheckedModeBanner: false,
              darkTheme: ThemeData.dark(),
              themeMode: ThemeMode.dark,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              routerConfig: router,
            ),
          );
        });
  }
}
