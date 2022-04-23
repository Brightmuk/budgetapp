import 'dart:io';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/widgets/action_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SingleBudgetPlan extends StatefulWidget {
  final String budgetPlanId;
  const SingleBudgetPlan({Key? key, required this.budgetPlanId})
      : super(key: key);

  @override
  _SingleBudgetPlanState createState() => _SingleBudgetPlanState();
}

class _SingleBudgetPlanState extends State<SingleBudgetPlan> {
  final DateFormat dayDate = DateFormat('EEE dd, yyy');
  late bool remider = true;
  late bool save = true;
  bool exportAsPdf = true;

  List<Expense> items = [];

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
                      'Budget plan',
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
        body: FutureBuilder<BudgetPlan>(
            future: BudgetPlanService(context: context)
                .singleBudgetPlan(widget.budgetPlanId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.hasData) {
                BudgetPlan? plan = snapshot.data;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(children: <Widget>[
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      plan!.title,
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
                        'Date',
                        style: TextStyle(
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                      trailing: Text(
                        dayDate.format(plan.date),
                        style: TextStyle(
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                    ),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.greenAccent,
                        value: plan.reminder,
                        title: Text(
                          'Reminder ',
                          style: TextStyle(
                            fontSize: AppSizes.normalFontSize.sp,
                          ),
                        ),
                        subtitle: Text(
                          'You will be reminded to fullfil the budget list',
                          style: TextStyle(
                            fontSize: AppSizes.normalFontSize.sp,
                          ),
                        ),
                        onChanged: (val) {
                          // setState(() {
                          //   remider = val!;
                          // });
                        }),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.monetization_on_outlined,
                        size: AppSizes.iconSize.sp,
                      ),
                      title: Text(
                        'Total',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                      trailing: Text(
                        'ksh.' + plan.total.toString(),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Expenses',
                      style: TextStyle(
                          fontSize: AppSizes.normalFontSize.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    Expanded(
                        child: ListView.builder(
                            itemCount: plan.expenses.length,
                            itemBuilder: (context, index) {
                              return Dismissible(
                                dismissThresholds: const {
                                  DismissDirection.startToEnd: 0.7,
                                },
                                direction: DismissDirection.startToEnd,
                                background: Container(
                                  padding: const EdgeInsets.all(10),
                                  color: Colors.redAccent,
                                  child: Row(
                                    children: [
                                      Icon(
                                        Icons.delete_outline,
                                        size: AppSizes.iconSize.sp,
                                      ),
                                    ],
                                  ),
                                ),
                                key: Key(index.toString()),
                                onDismissed: (val) {
                                  setState(() {
                                    // expenses.removeAt(index);
                                  });
                                },
                                child: ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  title: Text(
                                    plan.expenses[index].name.toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  subtitle: Text(
                                    plan.expenses[index].quantity.toString() +
                                        ' unit(s) @ ksh.' +
                                        plan.expenses[index].price.toString(),
                                    style: TextStyle(
                                      fontSize: AppSizes.normalFontSize.sp,
                                    ),
                                  ),
                                  trailing: Text(
                                    'ksh.' +
                                        (plan.expenses[index].quantity *
                                                plan.expenses[index].price)
                                            .toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: AppSizes.normalFontSize.sp),
                                  ),
                                ),
                              );
                            })),
                    SizedBox(
                      height: 150.sp,
                    ),
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
                  BudgetPlan _plan = await BudgetPlanService(context: context)
                      .singleBudgetPlan(widget.budgetPlanId);
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20)),
                      context: context,
                      builder: (context) => AddBudgetPlan(plan: _plan));
                },
                backgroundColor: AppColors.themeColor,
              ),
              
              FloatingActionButton.extended(
                heroTag: 'Delete',
                label: Text(
                  'delete',
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
                                'Are you sure you want to delete this budget plan?',
                            action: () {},
                            actionBtnText: 'Delete',
                          ));
                },
                backgroundColor: AppColors.themeColor,
              ),
              FloatingActionButton.extended(
                heroTag: 'print',
                label: Text(
                  'Print',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.normalFontSize.sp),
                ),
                icon: Icon(
                  Icons.print_outlined,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
                onPressed: () async {
                  BudgetPlan plan = await BudgetPlanService(context: context)
                      .singleBudgetPlan(widget.budgetPlanId);
                  File pdf = await PDFService.createPdf(plan);
                  await Printing.layoutPdf(
                      name: '${plan.title}.pdf',
                      onLayout: (format) async => pdf.readAsBytes());
                },
                backgroundColor: AppColors.themeColor,
              ),
              FloatingActionButton.extended(
                heroTag: 'share',
                label: Text(
                  'Share',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: AppSizes.normalFontSize.sp),
                ),
                icon: Icon(
                  Icons.share_outlined,
                  color: Colors.white,
                  size: AppSizes.iconSize.sp,
                ),
                onPressed: () async {
                  BudgetPlan plan = await BudgetPlanService(context: context)
                      .singleBudgetPlan(widget.budgetPlanId);
                  File pdf = await PDFService.createPdf(plan);
                  await Printing.sharePdf(
                      bytes: pdf.readAsBytesSync(),
                      filename: '${plan.title}.pdf');
                },
                backgroundColor: AppColors.themeColor,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
