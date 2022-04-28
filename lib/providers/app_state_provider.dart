import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:flutter/foundation.dart';


class AppState extends ChangeNotifier {

  void reload() {
    notifyListeners();
  }

}
