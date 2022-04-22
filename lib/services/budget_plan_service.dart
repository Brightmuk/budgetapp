import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';

import 'package:localstore/localstore.dart';

class BudgetPlanService {
  final BuildContext context;
  BudgetPlanService({required this.context});

  static const String budgetPlanCollection = 'budgetPlanCollection';
  final db = Localstore.instance;

  ///Create a new budget plan
  Future<bool> newBudgetPlan({required BudgetPlan budgetPlan}) async {
    bool returnValue = true;
    LoadService(context: context).showLoader();

    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlan.id)
        .set(budgetPlan.toMap())
        .then((value) {
      LoadService(context: context).hideLoader();
      ToastServcie.showToast('Budget plan saved!');
      returnValue = true;
    }).catchError((e) {
      LoadService(context: context).hideLoader();
      ToastServcie.showToast('An error occurred!');
      returnValue = false;
    });
    return returnValue;
  }

  ///Get single budget plan
  Future<BudgetPlan> singleBudgetPlan(String budgetPlanId) async {

    return await db
        .collection(budgetPlanCollection)
        .doc(budgetPlanId)
        .get()
        .then((value) => BudgetPlan.fromMap(value!));
  }

  ///Get budget plans
  Stream<List<BudgetPlan>> get budgetPlansStream {
    return db.collection(budgetPlanCollection).stream.map(budgetPlanList);
  }

  List<BudgetPlan> budgetPlanList(Map<String, dynamic> query) {
    print(query.entries);
    return [];
  }

  ///Delete a budget plan
  Future<void> deleteBudgetPlan({required String budgetPlanId}) async {
    LoadService(context: context).showLoader();
    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlanId)
        .delete()
        .then((value) => ToastServcie.showToast('Budget plan deleted!'))
        .catchError((e) => ToastServcie.showToast('An error occurred!'));
    LoadService(context: context).hideLoader();
  }

  ///Edit a budget plan
  Future<void> editBudgetPlan(
      {required String field,
      required dynamic value,
      required String budgetPlanId}) async {
    LoadService(context: context).showLoader();
    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlanId)
        .set({field: value}, SetOptions(merge: true))
        .then((value) => ToastServcie.showToast('Budget plan edited!'))
        .catchError((e) => ToastServcie.showToast('An error occurred!'));
    LoadService(context: context).hideLoader();
  }
}
