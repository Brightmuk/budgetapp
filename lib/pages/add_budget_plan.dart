import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/pages/single_budget_plan.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:budgetapp/services/date_services.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:timezone/timezone.dart' as tz;

class AddBudgetPlan extends StatefulWidget {
  ///This is parsed when in edit mode
  ///If not null then it means its an edit operation
  final BudgetPlan? plan;
  const AddBudgetPlan({Key? key, this.plan}) : super(key: key);

  @override
  _AddBudgetPlanState createState() => _AddBudgetPlanState();
}

class _AddBudgetPlanState extends State<AddBudgetPlan> {
  final TextEditingController _titleC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();

  DateTime? _selectedDate = DateTime.now();
  late bool remider = true;
  bool exportAsPdf = true;
  int total = 0;
  bool expenseError = false;
  bool editMode = false;

  List<Expense> _expenses = [];

  void initState() {
    super.initState();
    editMode = widget.plan != null;
    if (widget.plan != null) {
      _expenses = widget.plan!.expenses;
      total = widget.plan!.total;
      remider = widget.plan!.reminder;
      _selectedDate = widget.plan!.reminderDate;
      _titleC.text = widget.plan!.title;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editMode ? 'Edit Spending Plan' : 'Add a new Spending plan',
                    style:
                        TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(
                        Icons.clear_outlined,
                        size: AppSizes.iconSize.sp,
                      ))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: _titleC,
                  cursorColor: AppColors.themeColor,
                  decoration: AppStyles().textFieldDecoration(
                      label: 'Title', hintText: "John's Birthday"),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Title is required';
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text('Edit list'),
                subtitle: Text('${_expenses.length} expense(s) in list'),
                trailing: Text(
                  'Ksh.$total',
                  style:
                      TextStyle(fontWeight: FontWeight.bold, fontSize: 35.sp),
                ),
                onTap: () async {
                  _focusNode.unfocus();
                  var result =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateList(
                                title: _titleC.value.text,
                                expenses: _expenses,
                              )));
                  if (result != null) {
                    setState(() {
                      _expenses = result['expenses'];
                      total = result['total'];
                    });
                  }
                },
              ),
              Visibility(
                  visible: expenseError,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Row(
                      children: [
                        Text(
                          'Add at least one expense',
                          style: TextStyle(
                              color: Colors.redAccent, fontSize: 25.sp),
                        ),
                      ],
                    ),
                  )),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text(
                  'Reminder date',
                  style: TextStyle(fontSize: 35.sp),
                ),
                trailing: DateServices(context: context)
                    .dayDateTimeText(_selectedDate!),
                onTap: () async {
                  _focusNode.unfocus();
                  final dateResult = await DateServices(context: context)
                      .getDateAndTime(_selectedDate!);
                  if (dateResult != null) {
                    setState(() {
                      _selectedDate = dateResult;
                    });
                  }
                },
              ),
              CheckboxListTile(
                  activeColor: Colors.greenAccent,
                  value: remider,
                  title: Text('Set reminder on',
                      style: TextStyle(fontSize: 35.sp)),
                  subtitle: Text(
                      'You will be reminded to fullfil the Spending list',
                      style: TextStyle(fontSize: 35.sp)),
                  onChanged: (val) {
                    _focusNode.unfocus();
                    setState(() {
                      remider = val!;
                    });
                  }),
            ]),
            Positioned(
              bottom: 10,
              child: MaterialButton(
                  padding: const EdgeInsets.all(20),
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  color: AppColors.themeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () async {
                    if (_expenses.isEmpty) {
                      setState(() {
                        expenseError = true;
                      });
                      return;
                    }
                    if (_formKey.currentState!.validate()) {
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      BudgetPlan plan = BudgetPlan(
                        ///If in edit mode use the items id and not new one
                        id: editMode ? widget.plan!.id : id,
                        total: total,
                        reminderDate: _selectedDate!,
                        creationDate: DateTime.now(),
                        title: _titleC.value.text,
                        reminder: remider,
                        expenses: _expenses,
                      );

                      await BudgetPlanService(context: context)
                          .saveBudgetPlan(budgetPlan: plan)
                          .then((value) async {
                        if (value) {
                          await NotificationService().zonedScheduleNotification(
                              id: int.parse(plan.id.substring(8)),
                              payload: '{"id":$id,"type":"spendingPlan"}',
                              title: 'Spending list fulfilment',
                              description:
                                  'Remember to fulfil your spending list Buddy!',
                              scheduling:
                                  tz.TZDateTime.fromMillisecondsSinceEpoch(
                                      tz.local,
                                      plan.reminderDate
                                          .millisecondsSinceEpoch));

                          ///If in edit mode pop twice
                          if (editMode) {
                            Navigator.pop(context);
                          }
                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>

                                  ///If in edit mode use the items id and not new one
                                  SingleBudgetPlan(
                                    budgetPlanId:
                                        editMode ? widget.plan!.id : id,
                                  )));
                        }
                      });
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
