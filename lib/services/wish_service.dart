import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class WishService {
  final BuildContext? context;
  WishService({this.context});

  static const String wishCollection = 'wishCollection';
  final db = Localstore.instance;

  ///Create a new wish
  ///or edit a wish
  Future<bool> saveWish({required Wish wish}) async {
    bool returnValue = true;
    LoadService(context: context!).showLoader();
    await db
        .collection(wishCollection)
        .doc(wish.id)
        .set(wish.toMap())
        .then((value) {
      // ToastServcie.showToast('Wish saved!');
      returnValue = true;
    }).catchError((e) {
      // ToastServcie.showToast('An error occurred!');
      returnValue = false;
    });
    LoadService(context: context!).hideLoader();
    return returnValue;
  }

  ///Get single wish
  Future<Wish> singleWish(String wishId) async {
    return await db
        .collection(wishCollection)
        .doc(wishId)
        .get()
        .then((value) => Wish.fromMap(value!));
  }

  ///Get wish list
  Stream<List<Wish>> get wishStream {
    return db.collection(wishCollection).stream.map(wishList);
  }

  final List<Wish> _items = [];

  ///Yield the list from stream
  List<Wish> wishList(Map<String, dynamic> query) {
        final item = Wish.fromMap(query);

    //Get the item in a list first before we can add it to stream result
    Iterable<Wish> wish = _items.where((val) => val.id == item.id);
    if (!wish.isNotEmpty) {
      _items.add(item);
    } else {
      _items.remove(wish.first);
      _items.add(item);
    }
    return _items;
  }

  ///Delete a wish
  Future<void> deleteWish({required String wishId}) async {
    LoadService(context: context!).showLoader();
    await db
        .collection(wishCollection)
        .doc(wishId)
        .delete()
        .then((value) =>
            ToastService(context: context!).showSuccessToast('Wish deleted!'))
        .catchError((e) => ToastService(context: context!)
            .showSuccessToast('An error occurred!'));
    Navigator.pop(context!);
    LoadService(context: context!).hideLoader();
  }

  ///Edit a wish
  Future<void> editWish(
      {required String field,
      required dynamic value,
      required String wishId}) async {
    LoadService(context: context!).showLoader();
    await db
        .collection(wishCollection)
        .doc(wishId)
        .set({field: value}, SetOptions(merge: true))
        .then((value) =>
            ToastService(context: context!).showSuccessToast('Wish edited!'))
        .catchError((e) => ToastService(context: context!)
            .showSuccessToast('An error occurred!'));
    LoadService(context: context!).hideLoader();
  }
}
