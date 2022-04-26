import 'dart:async';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/add_wish.dart';
import 'package:budgetapp/pages/single_budget_plan.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:budgetapp/widgets/action_dialogue.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BudgetListTab extends StatefulWidget {
  const BudgetListTab({Key? key}) : super(key: key);

  @override
  _BudgetListTabState createState() => _BudgetListTabState();
}

class _BudgetListTabState extends State<BudgetListTab> {
  final ScrollController _controller = ScrollController();
  final DateFormat dayDate = DateFormat('EEE dd, yyy');
  bool hasItems = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<BudgetPlan>>(
        stream: BudgetPlanService(context: context).budgetPlansStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          // if(snapshot.connectionState==ConnectionState.waiting){
          //    return LoadService.dataLoader;
          // }
          if (snapshot.hasData) {
            List<BudgetPlan>? plans = snapshot.data;
            return ListView.builder(
                controller: _controller,
                itemCount: plans!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Ink(
                      child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SingleBudgetPlan(
                                      budgetPlanId: plans[index].id,
                                    )));
                          },
                          leading: Icon(
                            Icons.receipt_long_outlined,
                            size: AppSizes.iconSize.sp,
                            color: Colors.pinkAccent,
                          ),
                          title: Text(
                            plans[index].title,
                            style:
                                TextStyle(fontSize: AppSizes.normalFontSize.sp),
                          ),
                          subtitle: Text(
                              dayDate.format(
                                plans[index].date,
                              ),
                              style: TextStyle(
                                  fontSize: AppSizes.normalFontSize.sp)),
                          trailing: Text(
                            'Ksh.${plans[index].total}',
                            style:
                                TextStyle(fontSize: AppSizes.normalFontSize.sp),
                          )),
                    ),
                  );
                });
          } else {
            return Column(
              children: [
                SizedBox(
                  height: 50.sp,
                ),
                Image.asset(
                  'assets/images/no_spending_plan.png',
                  width: 700.sp,
                ),
                SizedBox(
                  height: 50.sp,
                ),
                Text(
                  'No Spending plans yet',
                  style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
                ),
                SizedBox(
                  height: 30.sp,
                ),
                MaterialButton(
                    elevation: 0,
                    color: AppColors.themeColor.withOpacity(0.3),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: (context) => const AddBudgetPlan());
                    },
                    child: const Text(
                      'CREAT ONE',
                      style: TextStyle(color: AppColors.themeColor),
                    )),
              ],
            );
          }
        });
  }
}

class WishListTab extends StatefulWidget {
  const WishListTab({Key? key}) : super(key: key);

  @override
  _WishListTabState createState() => _WishListTabState();
}

class _WishListTabState extends State<WishListTab> {
  final ScrollController _controller = ScrollController();
  final DateFormat dayDate = DateFormat('EEE dd, yyy');
  bool hasItems = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Wish>>(
        stream: WishService(context: context).wishStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(snapshot.error.toString()),
            );
          }
          // if(snapshot.connectionState==ConnectionState.waiting){
          //    return LoadService.dataLoader;
          // }
          if (snapshot.hasData) {
            List<Wish>? plans = snapshot.data;
            return ListView.builder(
                controller: _controller,
                itemCount: plans!.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    child: Ink(
                      child: ListTile(
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SingleWish(
                                      wishId: plans[index].id,
                                    )));
                          },
                          leading: Icon(
                            Icons.shopping_cart_outlined,
                            size: AppSizes.iconSize.sp,
                            color: Colors.orangeAccent,
                          ),
                          title: Text(
                            plans[index].name,
                            style:
                                TextStyle(fontSize: AppSizes.normalFontSize.sp),
                          ),
                          subtitle: Text(dayDate.format(plans[index].date),
                              style: TextStyle(
                                  fontSize: AppSizes.normalFontSize.sp)),
                          trailing: Text(
                            'Ksh.${plans[index].price}',
                            style:
                                TextStyle(fontSize: AppSizes.normalFontSize.sp),
                          )),
                    ),
                  );
                });
          } else {
            return Column(
              children: [
                SizedBox(
                  height: 50.sp,
                ),
                Image.asset(
                  'assets/images/no_wish.png',
                  width: 700.sp,
                ),
                SizedBox(
                  height: 50.sp,
                ),
                Text(
                  'No wishes yet',
                  style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
                ),
                SizedBox(
                  height: 30.sp,
                ),
                MaterialButton(
                    elevation: 0,
                    color: AppColors.themeColor.withOpacity(0.3),
                    onPressed: () {
                      showModalBottomSheet(
                          isScrollControlled: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: (context) => const AddWish());
                    },
                    child: const Text(
                      'CREAT ONE',
                      style: TextStyle(color: AppColors.themeColor),
                    )),
              ],
            );
          }
        });
  }
}
