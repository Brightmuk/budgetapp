
import 'package:budgetapp/bloc/app_bloc.dart';
import 'package:budgetapp/models/notification_model.dart';
import 'package:budgetapp/navigation/routes.dart';
import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/add_wish.dart';
import 'package:budgetapp/pages/home.dart';
import 'package:budgetapp/pages/settings.dart';
import 'package:budgetapp/pages/single_spending_plan.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/pages/splash_screen.dart';
import 'package:budgetapp/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

final getIt = GetIt.instance;

NotificationPayload? payload;

void setUp() {
  getIt.registerSingleton<AppBloc>(AppBloc());
}

final router = GoRouter(
  routes: [
    GoRoute(
      path: AppLinks.home,
      builder: (context, state) => const Wrapper(),
    ),
    GoRoute(
        path: AppLinks.splash,
        builder: (context, state) {
          return const SplashScreen();
        }),
    GoRoute(
      path: AppLinks.singleBudgetPlan,
      builder: (context, state) =>
          SingleBudgetPlan(budgetPlanId: state.extra as String),
    ),
    GoRoute(
      path: AppLinks.singleWish,
      builder: (context, state) =>
          SingleWish(wishId: state.extra as String),
    ),
    GoRoute(
      path: AppLinks.addBudget,
      builder: (context, state) => const AddBudgetPlan(),
    ),
    GoRoute(
      path: AppLinks.addWish,
      builder: (context, state) => const AddWish(),
    ),
    GoRoute(
      path: AppLinks.home,
      builder: (context, state) => const MyHomePage(),
    ),
    GoRoute(
      path: AppLinks.settings,
      builder: (context, state) => const SettingsPage(),
    ),
  ],
);

Widget buildApp(Widget child) {
  return MultiBlocProvider(
    providers: [
      BlocProvider(
        create: (context) => getIt<AppBloc>(),
      ),
    ],
    child: child,
  );
}
