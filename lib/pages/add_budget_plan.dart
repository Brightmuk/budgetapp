
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/pages/single_budget_plan.dart';
import 'package:budgetapp/services/budget_plan_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class AddBudgetPlan extends StatefulWidget {
  const AddBudgetPlan({
    Key? key,
  }) : super(key: key);

  @override
  _AddBudgetPlanState createState() => _AddBudgetPlanState();
}

class _AddBudgetPlanState extends State<AddBudgetPlan> {
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
      height: MediaQuery.of(context).size.height * 0.7,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Add a new Budget plan',
                    style: TextStyle(fontSize: 40.sp, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: Icon(Icons.clear_outlined,size: AppSizes.iconSize.sp,))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _titleC,
                  cursorColor: AppColors.themeColor,
                  decoration: AppStyles().textFieldDecoration(label:'Title',hintText: "John's Birthday"),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'The title is required';
                    }
                  },
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text('Edit list'),
                subtitle: Text('${items.length} item(s) in list'),
                trailing: Text(
                  'Ksh.23,000',
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 35.sp),
                ),
                onTap: () async {
                  var result =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CreateList(
                                title: _titleC.value.text,
                              )));
                  setState(() {
                    items = result;
                  });
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.calendar_month_outlined),
                title: Text('Select date',style: TextStyle(fontSize: 35.sp),),
                trailing: Text(dayDate.format(_selectedDate),style: TextStyle(fontSize: 35.sp)),
                onTap: () async {
                  final result = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 10)),
                    builder: (context, child) {
                      return Theme(
                        data: Theme.of(context).copyWith(
                          colorScheme: const ColorScheme.light(
                            onSurface: AppColors.themeColor,

                            primary: AppColors.themeColor,
                            // header background color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              primary: const Color.fromRGBO(72, 191, 132, 1),
                            ),
                          ),
                        ),
                        child: child!,
                      );
                    },
                  );
                  if (result != null) {
                    setState(() {
                      _selectedDate = result;
                    });
                  }
                },
              ),
              CheckboxListTile(
                  activeColor: Colors.greenAccent,
                  value: remider,
                  title: Text('Set reminder on',style: TextStyle(fontSize: 35.sp)),
                  subtitle: Text(
                      'You will be reminded to fullfil the budget list',style: TextStyle(fontSize: 35.sp)),
                  onChanged: (val) {
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
                  onPressed: ()async {
                    String id = DateTime.now().millisecondsSinceEpoch.toString();
                    BudgetPlan plan = BudgetPlan(
                      id: id,
                      date: _selectedDate,
                      title: _titleC.value.text,
                      reminder: remider,
                      items: [],
                    );
                    await BudgetPlanService(context: context).newBudgetPlan(budgetPlan: plan)
                    .then((value){
                      if(value){
                        Navigator.pop(context);
                        Navigator.of(context).push(MaterialPageRoute(builder: (context)=>SingleBudgetPlan(budgetPlanId: id)));
                      }
                    });
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
