import 'dart:async';
import 'package:budgetapp/l10n/app_localizations.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';

import 'package:localstore/localstore.dart';

class BudgetPlanService {
  final BuildContext? context;
  final ApplicationState appState;
  BudgetPlanService({this.context, required this.appState});

  static const String budgetPlanCollection = 'budgetPlanCollection';
  final db = Localstore.instance;

  ///Create a new budget plan
  ///or edit a budget plan
  Future<bool> saveBudgetPlan({required SpendingPlan budgetPlan}) async {
    bool returnValue = true;
   
    final l10n = AppLocalizations.of(context!)!;
    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlan.id)
        .set(budgetPlan.toMap())
        .then((value) {
     
      ToastService(context: context!).showSuccessToast(l10n.spending_plan_saved);

      returnValue = true;
    }).catchError((e) {
     
      ToastService(context: context!).showSuccessToast(l10n.an_error_occurred);
      returnValue = false;
    });
    return returnValue;
  }

  ///Get single budget plan
  Future<SpendingPlan> singleBudgetPlan(String budgetPlanId) async {
    return await db
        .collection(budgetPlanCollection)
        .doc(budgetPlanId)
        .get()
        .then((value) => SpendingPlan.fromMap(value!));
  }

  Stream<List<SpendingPlan>> get budgetPlansStream {
    return db
        .collection(budgetPlanCollection)
        .stream
        .asBroadcastStream()
        .map(budgetPlanList);
  }

  ///Yield the list from stream
  List<SpendingPlan> budgetPlanList(Map<String, dynamic> query) {
    final item = SpendingPlan.fromMap(query);

    //Get the item in a list first before we can add it to stream result
    Iterable<SpendingPlan> plan =
        appState.budgetPlans.where((val) => val.id == item.id);
    if (!plan.isNotEmpty) {
      appState.budgetPlans.add(item);
    } else {
      appState.budgetPlans.remove(plan.first);
      appState.budgetPlans.add(item);
    }
    appState.budgetPlans
        .sort((a, b) => b.creationDate.compareTo(a.creationDate));
    return appState.budgetPlans;
  }

  ///Delete a budget plan
  Future<void> deleteBudgetPlan({required String budgetPlanId}) async {
   final l10n = AppLocalizations.of(context!)!;
    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlanId)
        .delete()
        .then((value) {
      appState.deleteBudgetPlan(budgetPlanId);
      ToastService(context: context!)
          .showSuccessToast(l10n.spending_plan_deleted);
    }).catchError((e) {
      ToastService(context: context!).showSuccessToast(l10n.an_error_occurred);
    });
    Navigator.pop(context!);
   
  }


}
