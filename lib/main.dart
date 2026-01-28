import 'package:budgetapp/core/theme.dart';
import 'package:budgetapp/cubit/app_setup_cubit.dart';
import 'package:budgetapp/router.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:provider/provider.dart';
import 'package:overlay_support/overlay_support.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  NotificationService().init();
  MobileAds.instance.initialize();
  ScreenUtil.ensureScreenSize();

  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ApplicationState()), BlocProvider(create:  (c)=> AppSetupCubit())],
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
            themeMode: ThemeMode.system,
            theme: lightTheme,
            darkTheme: darkTheme,
            routerConfig: router,
          ),
        );
      },
    );
  }
}
