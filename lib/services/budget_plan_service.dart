import 'dart:async';

import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';

import 'package:localstore/localstore.dart';

class BudgetPlanService {
  final BuildContext? context;
  BudgetPlanService({this.context});

  static const String budgetPlanCollection = 'budgetPlanCollection';
  final db = Localstore.instance;

  ///Create a new budget plan
  ///or edit a budget plan
  Future<bool> saveBudgetPlan({required SpendingPlan budgetPlan}) async {
    bool returnValue = true;
    LoadService(context: context!).showLoader();

    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlan.id)
        .set(budgetPlan.toMap())
        .then((value) {
      LoadService(context: context!).hideLoader();
      // ToastService(context: context!).showSuccessToast('Spending plan saved!');

      returnValue = true;
    }).catchError((e) {
      LoadService(context: context!).hideLoader();
      // ToastService(context: context!).showSuccessToast('An error occurred!');
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

  final List<SpendingPlan> _items = [];

  ///Yield the list from stream
  List<SpendingPlan> budgetPlanList(Map<String, dynamic> query) {
    final item = SpendingPlan.fromMap(query);

    //Get the item in a list first before we can add it to stream result
    Iterable<SpendingPlan> plan = _items.where((val) => val.id == item.id);
    if (!plan.isNotEmpty) {
      _items.add(item);
    } else {
      _items.remove(plan.first);
      _items.add(item);
    }
    _items.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    return _items;
  }

  ///Delete a budget plan
  Future<void> deleteBudgetPlan({required String budgetPlanId}) async {
    LoadService(context: context!).showLoader();
    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlanId)
        .delete()
        .then((value) => ToastService(context: context!)
            .showSuccessToast('Spending plan deleted!'))
        .catchError((e) => ToastService(context: context!)
            .showSuccessToast('An error occurred!'));
    _items.clear();
    Navigator.pop(context!);
    LoadService(context: context!).hideLoader();
  }

  ///Edit a budget plan
  Future<void> editBudgetPlan(
      {required String field,
      required dynamic value,
      required String budgetPlanId}) async {
    LoadService(context: context!).showLoader();
    await db
        .collection(budgetPlanCollection)
        .doc(budgetPlanId)
        .set({field: value}, SetOptions(merge: true))
        .then((value) => ToastService(context: context!)
            .showSuccessToast('Spending plan edited!'))
        .catchError((e) => ToastService(context: context!)
            .showSuccessToast('An error occurred!'));
    LoadService(context: context!).hideLoader();
  }
}
