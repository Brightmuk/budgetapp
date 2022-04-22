import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/pages/home_tabs.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/pages/settings.dart';
import 'package:budgetapp/widgets/expense_type.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  void initState() {
    super.initState();
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
      length: 3,
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
                SizedBox(height: 10.sp,),
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
                        showModalBottomSheet(
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => const SettingsPage());
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: Icon(Icons.settings_outlined,size: AppSizes.iconSize.sp,),
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
                        'Wed 13 Apr',
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
                  'COMPLETION',
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
                      CircularPercentIndicator(
                        radius: 150.0.sp,
                        lineWidth: 10.0.sp,
                        percent: 0.5,
                        backgroundColor: AppColors.themeColor,
                        center: Text(
                          '50%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                          ),
                        ),
                        progressColor: Colors.blueAccent,
                      ),
                      CircularPercentIndicator(
                        radius: 150.0.sp,
                        lineWidth: 10.0.sp,
                        percent: 0.7,
                        backgroundColor: AppColors.themeColor,
                        center: Text(
                          '70%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                          ),
                        ),
                        progressColor: Colors.pinkAccent,
                      ),
                      CircularPercentIndicator(
                        radius: 150.0.sp,
                        lineWidth: 10.0.sp,
                        percent: 0.2,
                        backgroundColor: AppColors.themeColor,
                        center: Text(
                          '20%',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 30.sp,
                          ),
                        ),
                        progressColor: Colors.orangeAccent,
                      ),
                    ]),
                TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicatorColor: Colors.white,
                    labelStyle: TextStyle(
                        color: Colors.white,
                        fontSize: 30.sp,
                        fontWeight: FontWeight.w300),
                    tabs: const [
                      Tab(
                        text: 'ALL',
                      ),
                      Tab(
                        text: 'BUDGET PLANS',
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
        body:  Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 50),
          child: TabBarView(
            children: [Container(),const BudgetListTab(), const WishListTab()],
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
                  style: TextStyle(color: Colors.white,fontSize: 35.sp),
                ),
                icon: Icon(Icons.edit, color: Colors.white,size: AppSizes.iconSize.sp,),
                onPressed: () {
                  showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => const CreateList());
                  // Navigator.of(context).push(MaterialPageRoute(
                  //     builder: (context) => const BudgetLists())
                  //     );
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
