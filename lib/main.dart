
import 'package:budgetapp/pages/single_spending_plan.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:budgetapp/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';

import 'package:overlay_support/overlay_support.dart';
import 'package:budgetapp/models/notification_model.dart';

///This is the payload from a notification click
NotificationPayload? payload;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  payload = await NotificationService().init();

  MobileAds.instance.initialize();

  await configureLocalTimeZone();
  await ScreenUtil.ensureScreenSize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 233, 213, 213),
      statusBarBrightness: Brightness.dark));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ApplicationState>.value(
        value: ApplicationState()
        )
    ],
    child: const MyApp()
    ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(1080, 2340),
        builder: (context,child) {
          return OverlaySupport.global(
            child: MaterialApp(
              initialRoute: payload==null?'/': payload!.route,
              debugShowCheckedModeBanner: false,
              darkTheme: ThemeData.dark(),
              themeMode: ThemeMode.dark,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              routes: {
                '/': (context) => const Wrapper(),
                '/singlePlan': (context) => SingleBudgetPlan(
                      budgetPlanId:payload!.itemId,
                    ),
                '/singleWish': (context) => SingleWish(
                      wishId: payload!.itemId,
                    ),
              },
             
            ),
          );
        });
  }
}

///Configure timezones
Future<void> configureLocalTimeZone() async {
  // tz.initializeTimeZones();
  // final String? timeZoneName = await FlutterNativeTimezone.getLocalTimezone();
  // tz.setLocalLocation(tz.getLocation(timeZoneName!));
}
