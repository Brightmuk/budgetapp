import 'package:admob_flutter/admob_flutter.dart';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/formatters.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/add_wish.dart';
import 'package:budgetapp/pages/single_spending_plan.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final AppState _appState = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder<List<SpendingPlan>>(
          stream: BudgetPlanService(context: context, appState: _appState)
              .budgetPlansStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              List<SpendingPlan>? plans = snapshot.data;
              return ListView.separated(
                  controller: _controller,
                  itemCount: plans!.length + 1,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (index == plans.length) {
                      return AdmobBanner(
                        adUnitId: 'ca-app-pub-1360540534588513/9843905660',
                        adSize: AdmobBannerSize.FULL_BANNER,
                        listener:
                            (AdmobAdEvent event, Map<String, dynamic>? args) {
                          debugPrint(args.toString());
                        },
                        onBannerCreated: (AdmobBannerController controller) {},
                      );
                    } else {
                      return InkWell(
                        child: Ink(
                            child: ListTile(
                          tileColor: AppColors.themeColor.withOpacity(0.03),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => SingleBudgetPlan(
                                      budgetPlanId: plans[index].id,
                                    )));
                          },
                          leading: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Icon(
                              Icons.receipt_long_outlined,
                              size: AppSizes.iconSize.sp,
                              color: Colors.pinkAccent,
                            ),
                          ),
                          title: Text(
                            plans[index].title,
                            style:
                                TextStyle(fontSize: AppSizes.normalFontSize.sp),
                          ),
                          subtitle: Text(
                              dayDate.format(
                                plans[index].creationDate,
                              ),
                              style: TextStyle(
                                  fontSize: AppSizes.normalFontSize.sp)),
                          trailing: Text('${_appState.currentCurrency} ${AppFormatters.moneyCommaStr(plans[index].total)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.normalFontSize.sp,
                                  ),
                                ),
                        )),
                      );
                    }
                  });
            } else {
              return Column(
                children: [
                  AdmobBanner(
                    adUnitId: 'ca-app-pub-1360540534588513/9843905660',
                    adSize: AdmobBannerSize.FULL_BANNER,
                    listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
                      debugPrint(args.toString());
                    },
                    onBannerCreated: (AdmobBannerController controller) {},
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Image.asset(
                    'assets/images/no_spending_plan.png',
                    width: 500.sp,
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
          }),
    );
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
    final AppState _appState = Provider.of<AppState>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: StreamBuilder<List<Wish>>(
          stream: WishService(context: context, appState: _appState).wishStream,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text(snapshot.error.toString()),
              );
            }

            if (snapshot.hasData) {
              List<Wish>? wishes = snapshot.data;
              return ListView.separated(
                  controller: _controller,
                  itemCount: wishes!.length + 1,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemBuilder: (context, index) {
                    if (index == wishes.length) {
                      return AdmobBanner(
                        adUnitId: 'ca-app-pub-1360540534588513/3235895594',
                        adSize: AdmobBannerSize.FULL_BANNER,
                        listener:
                            (AdmobAdEvent event, Map<String, dynamic>? args) {
                          debugPrint(args.toString());
                        },
                        onBannerCreated: (AdmobBannerController controller) {},
                      );
                    } else {
                      return InkWell(
                        child: Ink(
                          child: ListTile(
                            tileColor: AppColors.themeColor.withOpacity(0.03),
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => SingleWish(
                                        wishId: wishes[index].id,
                                      )));
                            },
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.shopping_cart_outlined,
                                size: AppSizes.iconSize.sp,
                                color: Colors.orangeAccent,
                              ),
                            ),
                            title: Text(
                              wishes[index].name,
                              style: TextStyle(
                                  fontSize: AppSizes.normalFontSize.sp),
                            ),
                            subtitle: Text(
                                dayDate.format(wishes[index].creationDate),
                                style: TextStyle(
                                    fontSize: AppSizes.normalFontSize.sp)),
                            trailing: Text('${AppFormatters.moneyCommaStr(wishes[index].price)} ${_appState.currentCurrency}',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: AppSizes.normalFontSize.sp,
                                    ),
                                  ),
                          ),
                        ),
                      );
                    }
                  });
            } else {
              return Column(
                children: [
                  AdmobBanner(
                    adUnitId: 'ca-app-pub-1360540534588513/3235895594',
                    adSize: AdmobBannerSize.FULL_BANNER,
                    listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
                      debugPrint(args.toString());
                    },
                    onBannerCreated: (AdmobBannerController controller) {},
                  ),
                  SizedBox(
                    height: 20.sp,
                  ),
                  Image.asset(
                    'assets/images/no_wish.png',
                    width: 500.sp,
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
          }),
    );
  }
}
