import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class WishService {
  final BuildContext context;
  WishService({required this.context});

  static const String wishCollection = 'wishCollection';
  final db = Localstore.instance;

  ///Create a new wish
  Future<void> newWish({required Wish wish}) async {
     LoadService(context: context).showLoader();
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await db
        .collection(wishCollection)
        .doc(id)
        .set(wish.toMap())
        .then((value) => ToastServcie.showToast('Wish saved!'))
        .catchError((e) => ToastServcie.showToast('An error occurred!'));
        Navigator.pop(context);
        LoadService(context: context).hideLoader();
  }

  ///Get wish list
  Stream<List<Wish>> get budgetPlansStream {
    return db.collection(wishCollection).stream.map(budgetPlanList);
  }

  List<Wish> budgetPlanList(Map<String, dynamic> query) {
    print(query.entries);
    return [];
  }

  ///Delete a wish
  Future<void> deleteWish({required String wishId}) async {
     LoadService(context: context).showLoader();
    String id = DateTime.now().millisecondsSinceEpoch.toString();
    await db
        .collection(wishCollection)
        .doc(id)
        .delete()
        .then((value) => ToastServcie.showToast('Wish deleted!'))
        .catchError((e) => ToastServcie.showToast('An error occurred!'));
         LoadService(context: context).hideLoader();
  }

  ///Edit a wish
  Future<void> editWish(
      {required String field,
      required dynamic value,
      required String wishId}) async {
         LoadService(context: context).showLoader();
    await db
        .collection(wishCollection)
        .doc(wishId)
        .set({field: value}, SetOptions(merge: true))
        .then((value) => ToastServcie.showToast('Wish edited!'))
        .catchError((e) => ToastServcie.showToast('An error occurred!'));
         LoadService(context: context).hideLoader();
  }
}