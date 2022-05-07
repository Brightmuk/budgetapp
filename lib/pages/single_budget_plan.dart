import 'dart:io';
import 'package:admob_flutter/admob_flutter.dart';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/formatters.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/date_services.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:budgetapp/widgets/action_dialogue.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

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

  late AdmobInterstitial interstitialAd;
  @override
  void initState() {
    super.initState();

    Admob.requestTrackingAuthorization();

    interstitialAd = AdmobInterstitial(
      adUnitId: 'ca-app-pub-1360540534588513/6335620084',
      listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
        if (event == AdmobAdEvent.closed) interstitialAd.load();
        debugPrint(args.toString());
      },
    );
    interstitialAd.load();
  }

  @override
  Widget build(BuildContext context) {
    final AppState _appState = Provider.of<AppState>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
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
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      FloatingActionButton.extended(
                        elevation: 0,
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
                          SpendingPlan plan = await BudgetPlanService(
                                  context: context, appState: _appState)
                              .singleBudgetPlan(widget.budgetPlanId);
                          File pdf = await PDFService.createPdf(plan);
                          await Printing.layoutPdf(
                              name: '${plan.title}.pdf',
                              onLayout: (format) async => pdf.readAsBytes());
                          if (!_appState.adShown) {
                            interstitialAd.show();
                            _appState.changeAdView();
                          }else{
                            _appState.changeAdView();
                          }
                        },
                        backgroundColor: AppColors.themeColor,
                      ),
                      FloatingActionButton.extended(
                        elevation: 0,
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
                          SpendingPlan plan = await BudgetPlanService(
                                  context: context, appState: _appState)
                              .singleBudgetPlan(widget.budgetPlanId);
                          File pdf = await PDFService.createPdf(plan);
                          await Printing.sharePdf(
                              bytes: pdf.readAsBytesSync(),
                              filename: '${plan.title}.pdf');
                           if (!_appState.adShown) {
                            interstitialAd.show();
                            _appState.changeAdView();
                          }else{
                            _appState.changeAdView();
                          }
                        },
                        backgroundColor: AppColors.themeColor,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Spending plan',
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
        ),
        body: FutureBuilder<SpendingPlan>(
            future: BudgetPlanService(context: context, appState: _appState)
                .singleBudgetPlan(widget.budgetPlanId),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text(snapshot.error.toString()),
                );
              }
              if (snapshot.hasData) {
                SpendingPlan? plan = snapshot.data;

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
                        ' ${AppFormatters.moneyCommaStr(plan.total)} ${_appState.currentCurrency}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                    ),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Icon(
                        Icons.calendar_month_outlined,
                        size: AppSizes.iconSize.sp,
                      ),
                      title: Text(
                        'Created on',
                        style: TextStyle(
                          fontSize: AppSizes.normalFontSize.sp,
                        ),
                      ),
                      trailing: DateServices(context: context)
                          .dayDateTimeText(plan.creationDate),
                    ),
                    Visibility(
                      visible: plan.reminder,
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
                            .dayDateTimeText(plan.reminderDate),
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
                          plan.reminder
                              ? 'You will be reminded to fullfil the Spending list'
                              : 'You will not be reminded to fullfil the Spending list',
                          style: TextStyle(
                            fontSize: AppSizes.normalFontSize.sp,
                          ),
                        ),
                        onChanged: null),
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
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: plan.expenses.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: EdgeInsets.zero,
                                title: Text(
                                  plan.expenses[index].name.toUpperCase(),
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,fontSize: 30.sp),
                                ),
                                subtitle: Text(
                                  plan.expenses[index].quantity.toString() +
                                      ' unit(s) @' +
                                      plan.expenses[index].price.toString() +
                                      ' ${_appState.currentCurrency}',
                                  style: TextStyle(
                                    fontSize: AppSizes.normalFontSize.sp,
                                  ),
                                ),
                                trailing: Text(
                                  '${AppFormatters.moneyCommaStr((plan.expenses[index].quantity * plan.expenses[index].price))} ${_appState.currentCurrency}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: AppSizes.normalFontSize.sp,
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
                  SpendingPlan _plan = await BudgetPlanService(
                          context: context, appState: _appState)
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
                                'Are you sure you want to delete this Spending plan?',
                            action: () {
                              BudgetPlanService(
                                      context: context, appState: _appState)
                                  .deleteBudgetPlan(
                                      budgetPlanId: widget.budgetPlanId);
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
