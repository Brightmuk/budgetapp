import 'package:budgetapp/pages/home.dart';
import 'package:budgetapp/pages/single_budget_plan.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:budgetapp/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
import 'package:flutter_native_timezone/flutter_native_timezone.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService().init();
  await configureLocalTimeZone();
  await ScreenUtil.ensureScreenSize();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 233, 213, 213),
      statusBarBrightness: Brightness.dark));

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 2340),
        builder: (context) {
          return MaterialApp(
            initialRoute: "/",
            debugShowCheckedModeBanner: false,
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            // routes: {
            //   '/': (context) => const MyHomePage(),
            //   '/singlePlan': (context) => SingleBudgetPlan(),
            //   '/singleWish': (context) => SingleWish(),
            // },
            home: const Wrapper(),
          );
        });
  }
}

///Configure timezones
Future<void> configureLocalTimeZone() async {
  tz.initializeTimeZones();
  final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  tz.setLocalLocation(tz.getLocation(timeZoneName!));
}

