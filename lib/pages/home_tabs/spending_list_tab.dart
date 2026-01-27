
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/formatters.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/navigation/routes.dart';
import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class SpendingListTab extends StatefulWidget {
  const SpendingListTab({Key? key}) : super(key: key);

  @override
  _SpendingListTabState createState() => _SpendingListTabState();
}

class _SpendingListTabState extends State<SpendingListTab> {
  final ScrollController _controller = ScrollController();

  bool hasItems = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationState _appState = Provider.of<ApplicationState>(context);
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
                  physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics()),
                  controller: _controller,
                  itemCount: plans!.length,
                  separatorBuilder: (context, index) {
                    return const SizedBox(
                      height: 3,
                    );
                  },
                  itemBuilder: (context, index) {
                    return SpendingListTile(
                      index: index,
                      plan: plans[index],
                    );
                  });
            } else {
              return Column(
                children: [
                
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

class SpendingListTile extends StatelessWidget {
  final SpendingPlan plan;
  final int index;
  const SpendingListTile({Key? key, required this.plan, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final DateFormat dayDate = DateFormat('EEE dd, yyy');
    final ApplicationState _appState = Provider.of<ApplicationState>(context);

    return ListTile(
              tileColor: AppColors.themeColor.withOpacity(0.03),
              onTap: () {
                context.push(
                  AppLinks.singleBudgetPlan,
                  extra: plan.id,
                );
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
                plan.title,
                style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
              ),
              subtitle: Text(
                  dayDate.format(
                    plan.creationDate,
                  ),
                  style: TextStyle(fontSize: AppSizes.normalFontSize.sp)),
              trailing: Text(
                '${_appState.currentCurrency} ${AppFormatters.moneyCommaStr(plan.total)}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: AppSizes.normalFontSize.sp,
                ),
              ),
            );
  }
}
