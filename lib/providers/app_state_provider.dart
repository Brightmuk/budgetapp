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

    String? savedCurrency = prefs.getString(SharedPrefs.currency);

    // if (savedCurrency != null) {
    //   currentCurrency = savedCurrency;
    // } else {
      String detectedCurrency = getCurrencyCode(context);
      currentCurrency = detectedCurrency;

      await prefs.setString(SharedPrefs.currency, detectedCurrency);
    // }

    notifyListeners();
  }

  // Updated to handle the Currency object from currency_picker
  void setCurrency(Currency currency) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String newCurrency = currency.symbol;

    await prefs.setString(SharedPrefs.currency, newCurrency);
    currentCurrency = newCurrency;

    notifyListeners();
  }

String getCurrencyCode(BuildContext context) {
  try {
    final String localeIdentifier = Localizations.localeOf(context).toString();
   
    var format = NumberFormat.simpleCurrency(locale: localeIdentifier);
    debugPrint('Full Locale: $localeIdentifier');
    debugPrint('Detected Symbol: ${format.currencySymbol}'); 
    debugPrint('Currency Name: ${format.currencyName}');
    return format.currencySymbol; 
  } catch (e) {
    return '\$'; 
  }
}

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
