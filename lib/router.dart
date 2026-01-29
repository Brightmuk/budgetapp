
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/notification_model.dart';
import 'package:budgetapp/pages/add_spending_plan.dart';
import 'package:budgetapp/pages/add_wish.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/pages/pdf_preview.dart';
import 'package:budgetapp/pages/settings.dart';
import 'package:budgetapp/pages/single_spending_plan.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/wrapper.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';


class AppLinks {
  static const String home = '/';
  static const String singleSpendingPlan = '/single-spending-plan';
  static const String singleWish = '/single-wish';
  static const String addSpendingPlan = '/add-budget';
  static const String addWish = '/add-wish';
  static const String settings = '/settings';
  static const String createList = '/create-list';
  static const String pdfPreview = '/pdf-preview';
}
final getIt = GetIt.instance;
NotificationPayload? payload;

final router = GoRouter(
  initialLocation: AppLinks.home,
  routes: [
    GoRoute(
      path: AppLinks.home,
      builder: (context, state) => const Wrapper(),
    ),

    GoRoute(
      path: AppLinks.singleSpendingPlan,
      builder: (context, state) =>
          SingleBudgetPlan(budgetPlanId: state.extra as String),
    ),
    GoRoute(
      path: AppLinks.singleWish,
      builder: (context, state) =>
          SingleWish(wishId: state.extra as String),
    ),
    GoRoute(
      path: AppLinks.addSpendingPlan,
      builder: (context, state) =>  AddBudgetPlan(
        plan: state.extra as SpendingPlan?,
      ),
    ),
    GoRoute(
      path: AppLinks.addWish,
      builder: (context, state) => const AddWish(),
    ),
    GoRoute(
      path: AppLinks.createList,
      builder: (context, state) => const CreateList(),
    ),

    GoRoute(
      path: AppLinks.settings,
      builder: (context, state) => const SettingsPage(),
    ),
    GoRoute(
      path: AppLinks.pdfPreview,
      builder: (context, state) =>  PdfPreviewScreen(plan: state.extra as SpendingPlan),
    ),
  ],
);


