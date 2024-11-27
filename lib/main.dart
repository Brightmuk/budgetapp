import 'package:admob_flutter/admob_flutter.dart';
import 'package:budgetapp/pages/home.dart';
import 'package:budgetapp/pages/single_spending_plan.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:budgetapp/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// import 'package:flutter_native_timezone/flutter_native_timezone.dart';
import 'package:overlay_support/overlay_support.dart';
import 'package:budgetapp/models/notification_model.dart';

///This is the payload from a notification click
NotificationPayload? payload;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  payload = await NotificationService().init();

  Admob.initialize(testDeviceIds: ["660d9cc2-2f05-4d59-9aa6-7b7b3fa8d56b"]);
  await configureLocalTimeZone();
  await ScreenUtil.ensureScreenSize();

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Color.fromARGB(0, 233, 213, 213),
      statusBarBrightness: Brightness.dark));

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<AppState>.value(
        value: AppState()
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
