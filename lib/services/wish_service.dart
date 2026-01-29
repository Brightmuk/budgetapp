import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:localstore/localstore.dart';

class WishService {
  final BuildContext? context;
  final ApplicationState appState;
  WishService({this.context, required this.appState});

  static const String wishCollection = 'wishCollection';
  final db = Localstore.instance;

  ///Create a new wish
  ///or edit a wish
  Future<bool> saveWish({required Wish wish}) async {
    bool returnValue = true;
    
    await db
        .collection(wishCollection)
        .doc(wish.id)
        .set(wish.toMap())
        .then((value) {
      ToastService(context: context!).showSuccessToast('Wish saved!');
      returnValue = true;
    }).catchError((e) {
      ToastService(context: context!).showSuccessToast('An error occurred!');
      returnValue = false;
    });
   
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

  ///Yield the list from stream
  List<Wish> wishList(Map<String, dynamic> query) {
    final item = Wish.fromMap(query);

    //Get the item in a list first before we can add it to stream result
    Iterable<Wish> wish = appState.wishes.where((val) => val.id == item.id);
    if (!wish.isNotEmpty) {
      appState.wishes.add(item);
    } else {
      appState.wishes.remove(wish.first);
      appState.wishes.add(item);
    }
    appState.wishes.sort((a, b) => b.creationDate.compareTo(a.creationDate));
    return appState.wishes;
  }

  ///Delete a wish
  Future<void> deleteWish({required String wishId}) async {
   
    await db.collection(wishCollection).doc(wishId).delete().then((value) {
      appState.deleteWish(wishId);
      ToastService(context: context!).showSuccessToast('Wish deleted!');
    }).catchError((e) {
      ToastService(context: context!).showSuccessToast('An error occurred!');
    });
    Navigator.pop(context!);
   
  }

}
