import 'dart:io';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/add_wish.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/date_services.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:budgetapp/widgets/action_dialogue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleWish extends StatefulWidget {
  final String wishId;
  const SingleWish({Key? key, required this.wishId}) : super(key: key);

  @override
  _SingleWishState createState() => _SingleWishState();
}

class _SingleWishState extends State<SingleWish> {
  final DateFormat dayDate = DateFormat('EEE dd, yyy');
  late bool remider = true;
  late bool save = true;
  bool exportAsPdf = true;

  List<Expense> items = [];
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          toolbarHeight: AppSizes.minToolBarHeight,
          flexibleSpace: AnimatedContainer(
            padding: const EdgeInsets.all(15),
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.themeColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Wish',
                      style: TextStyle(
                          fontSize: AppSizes.titleFont.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.clear_outlined,
                        size: AppSizes.iconSize.sp,
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        body: FutureBuilder<Wish>(
            future: WishService(context: context).singleWish(widget.wishId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const Center(
                  child: Text('An error occurred'),
                );
              }
              if (snapshot.hasData) {
                Wish? wish = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      wish!.name,
                      style: TextStyle(
                          fontSize: AppSizes.normalFontSize.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.calendar_month_outlined,
                        size: AppSizes.iconSize.sp,
                      ),
                      title: Text(
                        'Creation Date',
                        style: TextStyle(
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                      trailing: DateServices(context: context)
                          .dayDateTimeText(wish.creationDate),
                    ),
                    Visibility(
                      visible: wish.reminder,
                      child: ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: Icon(
                          Icons.calendar_month_outlined,
                          size: AppSizes.iconSize.sp,
                        ),
                        title: Text(
                          'Reminder Date',
                          style: TextStyle(
                            fontSize: AppSizes.normalFontSize.sp,
                          ),
                        ),
                        trailing: DateServices(context: context)
                            .dayDateTimeText(wish.reminderDate),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.monetization_on_outlined,
                        size: AppSizes.iconSize.sp,
                      ),
                      title: Text(
                        'Price',
                        style: TextStyle(
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                      trailing: FutureBuilder<String?>(
                          future: SharedPrefs().getCurrency(),
                          builder: (context, sn) {
                            return Text(
                              sn.hasData
                                  ? '${sn.data!} ${wish.price.toString()}'
                                  : wish.price.toString(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.normalFontSize.sp,
                              ),
                            );
                          }),
                    ),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.greenAccent,
                        value: wish.reminder,
                        title: Text(
                          'Reminder ',
                          style: TextStyle(
                            fontSize: AppSizes.normalFontSize.sp,
                          ),
                        ),
                        subtitle: Text(
                          wish.reminder
                              ? 'You will be reminded to fullfil this wish'
                              : 'You will not be reminded to fullfil this wish',
                          style: TextStyle(
                            fontSize: AppSizes.normalFontSize.sp,
                          ),
                        ),
                        onChanged: null),
                    const Divider(),
                  ]),
                );
              } else {
                return LoadService.dataLoader;
              }
            }),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SizedBox(),
              FloatingActionButton.extended(
                heroTag: 'edit',
                label: Text(
                  'Edit',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.normalFontSize.sp),
                ),
                icon: Icon(
                  Icons.edit_outlined,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
                onPressed: () async {
                  Wish _wish = await WishService(context: context)
                      .singleWish(widget.wishId);
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      context: context,
                      builder: (context) => AddWish(wish: _wish));
                },
                backgroundColor: AppColors.themeColor,
              ),
              FloatingActionButton.extended(
                heroTag: 'delete',
                label: Text(
                  'Delete',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.normalFontSize.sp),
                ),
                icon: Icon(
                  Icons.delete_outline,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
                onPressed: () async {
                  showModalBottomSheet(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      context: context,
                      builder: (context) => ActionDialogue(
                            infoText:
                                'Are you sure you want to delete this wish?',
                            action: () {
                              WishService(context: context)
                                  .deleteWish(wishId: widget.wishId);
                            },
                            actionBtnText: 'Delete',
                          ));
                },
                backgroundColor: AppColors.themeColor,
              ),
              const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
