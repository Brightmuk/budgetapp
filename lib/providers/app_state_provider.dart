import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/foundation.dart';


class ApplicationState extends ChangeNotifier {
  String? currentCurrency;
  bool adShown = false;

  final List<SpendingPlan> budgetPlans = [];
  final List<Wish> wishes = [];

  ApplicationState() {
    init();
  }

  void init() async {
    currentCurrency = await SharedPrefs().getCurrency();
  }

  void changeAdView() {
    adShown = !adShown;
  }

  void setCurrency(Currency currency) {
    currentCurrency = currency.code;
    notifyListeners();
  }

  ///Remove from Ui
  void deleteWish(String wishId) {
    wishes.removeWhere((wish) => wish.id == wishId);
    notifyListeners();
  }

  ///Remove from Ui
  void deleteBudgetPlan(String planId) {
    budgetPlans.removeWhere((plan) => plan.id == planId);
    notifyListeners();
  }

}
