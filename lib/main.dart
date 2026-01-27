
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
