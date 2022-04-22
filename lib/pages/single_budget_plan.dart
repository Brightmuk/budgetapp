import 'dart:io';

import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/load_service.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class SingleBudgetPlan extends StatefulWidget {
  final String budgetPlanId;
  const SingleBudgetPlan({Key? key, required this.budgetPlanId})
      : super(key: key);

  @override
  _SingleBudgetPlanState createState() => _SingleBudgetPlanState();
}

class _SingleBudgetPlanState extends State<SingleBudgetPlan> {
  void initState() {
    super.initState();
  }

  final DateFormat dayDate = DateFormat('EEE dd, yyy');
  final TextEditingController _titleC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate = DateTime.now();
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
                    const Text(
                      'Budget plan',
                      style:
                          TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_outlined),
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
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(),
                    ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.calendar_month_outlined),
                      title: const Text('Date'),
                      trailing: Text(dayDate.format(plan.date)),
                    ),
                    CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        activeColor: Colors.greenAccent,
                        value: plan.reminder,
                        title: const Text('Reminder '),
                        subtitle: const Text(
                            'You will be reminded to fullfil the budget list'),
                        onChanged: (val) {
                          // setState(() {
                          //   remider = val!;
                          // });
                        }),
                    const Divider(),
                    Expanded(child:
                        ListView.builder(itemBuilder: (context, index) {
                      return Dismissible(
                        dismissThresholds: const {
                          DismissDirection.startToEnd: 0.7,
                        },
                        direction: DismissDirection.startToEnd,
                        background: Container(
                          padding: const EdgeInsets.all(10),
                          color: Colors.redAccent,
                          child: Row(
                            children: const [
                              Icon(Icons.delete_outline),
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
                          title: Text(
                            plan.items[index].name.toUpperCase(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              plan.items[index].quantity.toString() +
                                  ' unit(s) @ ksh.' +
                                  plan.items[index].price.toString()),
                          trailing: Text(
                            'ksh.' +
                                (plan.items[index].quantity *
                                        plan.items[index].price)
                                    .toString(),
                            style:
                                const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      );
                    }))
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
                heroTag: 'print',
                label: const Text(
                  'Print',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.print_outlined, color: Colors.white),
                onPressed: () async {
                  File pdf = await PDFService.createPdf('new');
                  await Printing.layoutPdf(
                      name: 'mydocument.pdf',
                      onLayout: (format) async => pdf.readAsBytes());
                },
                backgroundColor: AppColors.themeColor,
              ),
              FloatingActionButton.extended(
                heroTag: 'share',
                label: const Text(
                  'Share',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.share_outlined, color: Colors.white),
                onPressed: () async {
                  File pdf = await PDFService.createPdf('new');
                  await Printing.sharePdf(
                      bytes: pdf.readAsBytesSync(),
                      filename: 'my-document.pdf');
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
