import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/home_tabs.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/pages/settings.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:budgetapp/widgets/expense_type.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final DateFormat dayDate = DateFormat('EEE dd, yyy');

  void initState() {
    super.initState();

  }

  String bPTotal(List<BudgetPlan> plans) {
    int total = 0;
    for (var plan in plans) {
      total += plan.total;
    }
    return total.toString();
  }

  String wishTotal(List<Wish> wishes) {
    int total = 0;
    for (var wish in wishes) {
      total += wish.price;
    }

    return total.toString();
  }

  void newItem() {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        context: context,
        builder: (context) => const ExpenseType());
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          toolbarHeight: AppSizes.maxToolBarHeight,
          flexibleSpace: AnimatedContainer(
            duration: const Duration(seconds: 2),
            height: AppSizes(context: context).screenHeight * 0.4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: AppColors.themeColor,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  height: 10.sp,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Image.asset(
                        'assets/images/logo.png',
                        width: 80.sp,
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10.sp),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(color: Colors.white, width: 0.5),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const SettingsPage()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Icon(
                          Icons.settings_outlined,
                          size: AppSizes.iconSize.sp,
                        ),
                      ),
                    )
                  ],
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        dayDate.format(DateTime.now()),
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 70.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                const Divider(
                  height: 0,
                ),
                Text(
                  'TOTALS',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.sp,
                      fontWeight: FontWeight.w300),
                ),
                const Divider(
                  height: 0,
                ),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      StreamBuilder<List<BudgetPlan>>(
                          stream: BudgetPlanService(context: context)
                              .budgetPlansStream,
                          builder: (context, snapshot) {
                            return CircularPercentIndicator(
                              animation: true,
                              radius: 150.0.sp,
                              lineWidth: 15.0.sp,
                              percent: 1,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              center: Text(
                                snapshot.hasData
                                    ? bPTotal(snapshot.data!)
                                    : '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              progressColor: Colors.pinkAccent,
                            );
                          }),
                      StreamBuilder<List<Wish>>(
                          stream: WishService(context: context).wishStream,
                          builder: (context, snapshot) {
                            return CircularPercentIndicator(
                              animation: true,
                              radius: 150.0.sp,
                              lineWidth: 15.0.sp,
                              percent: 1,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              center: Text(
                                snapshot.hasData
                                    ? wishTotal(snapshot.data!)
                                    : '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              progressColor: Colors.orangeAccent,
                            );
                          }),
                    ]),
                TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.white,
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w300),
                    tabs: const [
                      // Tab(
                      //   text: 'OVERVIEW',
                      // ),
                      Tab(
                        text: 'SPENDING PLANS',
                      ),
                      Tab(
                        text: 'WISHLIST',
                      )
                    ]),
                const SizedBox(),
              ],
            ),
          ),
        ),
        body: const Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 50),
          child: TabBarView(
            children: [BudgetListTab(), WishListTab()],
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FloatingActionButton.extended(
                label: Text(
                  'Quick List',
                  style: TextStyle(color: Colors.white, fontSize: 35.sp),
                ),
                icon: Icon(
                  Icons.edit,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const CreateList(
                            expenses: [],
                          ));
                },
                backgroundColor: AppColors.themeColor,
              ),
              FloatingActionButton(
                heroTag: 'New',
                backgroundColor: AppColors.themeColor,
                onPressed: newItem,
                tooltip: 'New item',
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
