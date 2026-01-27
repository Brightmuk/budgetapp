import 'dart:convert';

import 'package:budgetapp/cubit/app_setup_cubit.dart';
import 'package:budgetapp/models/notification_model.dart';
import 'package:budgetapp/navigation/router.dart';
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
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
            ),
            routerConfig: router,
          ),
        );
      },
    );
  }
}
