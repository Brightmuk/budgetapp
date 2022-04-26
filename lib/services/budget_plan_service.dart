import 'dart:async';

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
  ///or edit a budget plan
  Future<bool> saveBudgetPlan({required BudgetPlan budgetPlan}) async {
    bool returnValue = true;
    LoadService(context: context).showLoader();

    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlan.id)
        .set(budgetPlan.toMap())
        .then((value) {
      LoadService(context: context).hideLoader();
      // ToastServcie.showToast('Budget plan saved!');
      returnValue = true;
    }).catchError((e) {
      LoadService(context: context).hideLoader();
      // ToastServcie.showToast('An error occurred!');
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



  final List<BudgetPlan> _items = [];

  ///Yield the list from stream
  List<BudgetPlan> budgetPlanList(Map<String, dynamic> query) {
    final item = BudgetPlan.fromMap(query);

    //Get the item in a list first before we can add it to stream result
    Iterable<BudgetPlan> plan = _items.where((val) => val.id == item.id);
    if (!plan.isNotEmpty) {
      _items.add(item);
    } else {
      _items.remove(plan.first);
      _items.add(item);
    }
    return _items;
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
