import 'package:budgetapp/pages/home.dart';
import 'package:budgetapp/pages/splash_screen.dart';
import 'package:budgetapp/pages/tour.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:flutter/material.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool?>(
        future: SharedPrefs().seenTour(),
        builder: (context, sn) {
          if (sn.hasData && sn.data!) {
            return const MyHomePage();
          } else if (sn.hasData && !sn.data!) {
            return const TourScreen(isFirstTime: true,);
          } else {
            return const SplashScreen();
          }
        });
  }
}
