import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApplicationState extends ChangeNotifier {
  String? currentCurrency;
  bool adShown = false;

  final List<SpendingPlan> budgetPlans = [];
  final List<Wish> wishes = [];


  void init(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String currency = getCurrencyCode(context);
    currentCurrency = currency;
    prefs.setString(SharedPrefs.currency, currency);
  }

  void changeAdView() {
    adShown = !adShown;
  }

  void setCurrency(Currency currency) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(SharedPrefs.currency, currency.code);
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

  String getCurrencyCode(BuildContext context) {
    Locale locale = Localizations.localeOf(context);
    var format = NumberFormat.simpleCurrency(locale: locale.toString());
    return format.currencyName ?? 'USD';
  }
}
