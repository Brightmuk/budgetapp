import 'dart:io';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/formatters.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/pages/add_budget_plan.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/services/shared_prefs.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:budgetapp/widgets/share_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class CreateList extends StatefulWidget {
  final String? title;
  final List<Expense>? expenses;
  const CreateList({Key? key, this.title, this.expenses}) : super(key: key);

  @override
  _CreateListState createState() => _CreateListState();
}

class _CreateListState extends State<CreateList> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _quantityC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final TextEditingController _amountToSpendC = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final ScrollController _sc = ScrollController();
  final _amountFormKey = GlobalKey<FormState>();

  List<Expense> expenses = [];
  bool reverseMode = false;
  int amountToSpend = 0;

  // late AdmobInterstitial interstitialAd;

  @override
  void initState() {
    super.initState();
    hasViewedReverse();

    expenses.addAll(widget.expenses!);

    _quantityC.text = '1';

    // Admob.requestTrackingAuthorization();

    // interstitialAd = AdmobInterstitial(
    //   adUnitId: 'ca-app-pub-1360540534588513/6335620084',
    //   listener: (AdmobAdEvent event, Map<String, dynamic>? args) {
    //     if (event == AdmobAdEvent.closed) interstitialAd.load();
    //     debugPrint(args.toString());
    //   },
    // );
    // interstitialAd.load();
  }

  int get _total {
    int sum = 0;
    for (Expense val in expenses) {
      sum += val.quantity * val.price;
    }
    return sum;
  }

  int get _balance {
    int sum = amountToSpend;
    for (Expense val in expenses) {
      sum -= val.quantity * val.price;
    }

    return sum;
  }

  @override
  Widget build(BuildContext context) {
    final ApplicationState _appState = Provider.of<ApplicationState>(context);

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: Container(),
          toolbarHeight: AppSizes.midToolBarHeight + 60,
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
                      
                      widget.title ?? 'Quick Spending Plan',
                      style: TextStyle(
                        color: Colors.white,
                          fontSize: 40.sp, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_outlined,color: Colors.white,),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Reverse Mode',style: TextStyle(color: Colors.white),),
                 inactiveTrackColor: const Color.fromARGB(255, 33, 136, 84),
                  activeColor: Colors.white,
                 
                  inactiveThumbColor: const Color.fromARGB(255, 231, 231, 231),
                  activeTrackColor: Color.fromARGB(255, 123, 209, 166),
                  value: reverseMode, onChanged: (val) {
                      if (val) {
                        showAmountInput();
                      } else {
                        setState(() {
                          amountToSpend = 0;
                        });
                      }
                      setState(() {
                        reverseMode = val;
                      });
                    } ),
                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      reverseMode ? 'Balance' : 'Total',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      width: AppSizes(context: context).screenWidth * 0.5,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${AppFormatters.moneyCommaStr(reverseMode ? _balance : _total)} ${_appState.currentCurrency} ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: AppSizes.normalFontSize.sp,
                                color: reverseMode && _balance < 0
                                    ? Colors.redAccent
                                    : Colors.white),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          Visibility(
                              visible: reverseMode,
                              child: GestureDetector(
                                child: const Icon(
                                  Icons.edit_outlined,
                                  size: 15,
                                ),
                                onTap: () {
                                  showAmountInput();
                                },
                              ))
                        ],
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        body: SingleChildScrollView(
          controller: _sc,
          child: Column(children: <Widget>[
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              height: expenses.length * 73,
              child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: expenses.length,
                  itemBuilder: (context, index) {
                    return Dismissible(
                      dismissThresholds: const {
                        DismissDirection.startToEnd: 0.7,
                      },
                      direction: DismissDirection.startToEnd,
                      background: Container(
                        padding: const EdgeInsets.all(10),
                        color: Colors.redAccent,
                        child: const Row(
                          children: [
                            Icon(Icons.delete_outline),
                          ],
                        ),
                      ),
                      key: UniqueKey(),
                      onDismissed: (val) {
                        setState(() {
                          expenses.removeAt(index);
                        });
                      },
                      child: ListTile(
                        title: Text(
                          expenses[index].name.toUpperCase(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text('${expenses[index].quantity} unit(s) @${AppFormatters.moneyCommaStr(expenses[index].price)} ${_appState.currentCurrency} '),
                        trailing: Text(
                          '${AppFormatters.moneyCommaStr((expenses[index].quantity * expenses[index].price))} ${_appState.currentCurrency}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
            ),
            SizedBox(
              height: 10.sp,
            ),
            Visibility(
              visible: expenses.isNotEmpty,
              child: Text('Swipe right on item to delete',
                  style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            ),
            SizedBox(
              height: 10.sp,
            ),
            expense(),
            SizedBox(
              height: 100.sp,
            ),
            Text('Hit enter to save item',
                style: TextStyle(fontSize: 13, color: Colors.grey[500])),
            SizedBox(
              height: 150.sp,
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton.extended(
            heroTag: 'Share',
            backgroundColor: AppColors.themeColor,
            onPressed: expenses.isNotEmpty
                ? () async {
                    if (widget.title != null) {
                      Navigator.pop(
                          context, {'expenses': expenses, 'total': _total});
                    } else {
                      if (expenses.isEmpty) {
                        return;
                      }
                      SpendingPlan plan = SpendingPlan(
                          id: DateTime.now().millisecondsSinceEpoch.toString(),
                          total: _total,
                          title: 'Quick Spending Plan',
                          creationDate: DateTime.now(),
                          reminderDate: DateTime.now(),
                          reminder: false,
                          expenses: expenses);
                      bool share = await showModalBottomSheet(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          context: context,
                          builder: (context) => const QuickListoptions());

                      if (share) {
                        File pdf = await PDFService.createPdf(plan);
                        await Printing.sharePdf(
                            bytes: pdf.readAsBytesSync(),
                            filename: '${plan.title}.pdf');
                      } else {
                        showModalBottomSheet(
                            isScrollControlled: true,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            context: context,
                            builder: (context) => AddBudgetPlan(plan: plan));
                      }
                      if (!_appState.adShown) {
                        // interstitialAd.show();
                        _appState.changeAdView();
                      } else {
                        _appState.changeAdView();
                      }
                    }
                  }
                : null,
            tooltip: 'Done',
            label: Text(
              'Done',
              style: TextStyle(color: Colors.white, fontSize: 35.sp),
            ),
            icon: Icon(
              Icons.done,
              color: Colors.white,
              size: 50.sp,
            )),
      ),
    );
  }
  // WidgetsBinding.instance!.window.viewInsets.bottom > 0.0?null:

  void scrollOnSave() {
    Future.delayed(Duration(milliseconds: 100), () {
      _sc.animateTo(_sc.position.maxScrollExtent,
          duration: Duration(milliseconds: 100), curve: Curves.fastOutSlowIn);
    });
  }

  Widget expense() => Padding(
        padding: const EdgeInsets.all(5.0),
        child: Form(
          key: _formKey,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: TextFormField(
                  focusNode: _focusNode,
                  controller: _nameC,
                  cursorColor: AppColors.themeColor,
                  onFieldSubmitted: (val) {
                    if (_formKey.currentState!.validate()) {
                      Expense exp = Expense(
                          price: int.parse(_priceC.value.text),
                          index: 0,
                          quantity: int.parse(_quantityC.value.text),
                          name: _nameC.value.text);
                      setState(() {
                        expenses.add(exp);
                      });
                      _nameC.clear();
                      _quantityC.text = '1';
                      _priceC.clear();
                      _focusNode.requestFocus();
                      scrollOnSave();
                    }
                  },
                  decoration: AppStyles()
                      .textFieldDecoration(label: 'Item', hintText: 'Food'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Item name is required';
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  scrollPadding: const EdgeInsets.only(bottom: 40),
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  controller: _quantityC,
                  onFieldSubmitted: (val) {
                    if (_formKey.currentState!.validate()) {
                      Expense exp = Expense(
                          price: int.parse(val),
                          index: 0,
                          quantity: int.parse(_quantityC.value.text),
                          name: _nameC.value.text);
                      setState(() {
                        expenses.add(exp);
                      });
                      _nameC.clear();
                      _quantityC.text = '1';
                      _priceC.clear();
                      _focusNode.requestFocus();
                      scrollOnSave();
                    }
                  },
                  cursorColor: AppColors.themeColor,
                  decoration: AppStyles().textFieldDecoration(
                    label: 'Quantity',
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextFormField(
                    keyboardType: TextInputType.number,
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    controller: _priceC,
                    onFieldSubmitted: (val) {
                      if (_formKey.currentState!.validate()) {
                        Expense exp = Expense(
                            price: int.parse(val),
                            index: 0,
                            quantity: int.parse(_quantityC.value.text),
                            name: _nameC.value.text);
                        setState(() {
                          expenses.add(exp);
                        });
                        _nameC.clear();
                        _quantityC.text = '1';
                        _priceC.clear();
                        _focusNode.requestFocus();
                        scrollOnSave();
                      }
                    },
                    cursorColor: AppColors.themeColor,
                    decoration: AppStyles().textFieldDecoration(
                        label: 'Unit Price', hintText: '300'),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'Price is required';
                      }
                      return null;
                    }),
              ),
            ],
          ),
        ),
      );

  void showAmountInput() {
    if (amountToSpend > 0) _amountToSpendC.text = amountToSpend.toString();
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => WillPopScope(
        onWillPop: () async {
          if (_amountToSpendC.value.text.isEmpty) {
            setState(() {
              reverseMode = false;
            });
          }
          _amountToSpendC.clear();
          return true;
        },
        child: AlertDialog(
          title: const Text('Amount to be spent'),
          content: Form(
            key: _amountFormKey,
            child: TextFormField(
              validator: (val) {
                if (val!.isEmpty) {
                  return 'Amount is required';
                }
              },
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: _amountToSpendC,
              onFieldSubmitted: (val) {
              
                if (_amountFormKey.currentState!.validate()) {
                  setState(() {
                    amountToSpend = int.parse(val);
                  });
                  _amountToSpendC.clear();
                  Navigator.pop(context);
                }
              },
              cursorColor: AppColors.themeColor,
              decoration: AppStyles()
                  .textFieldDecoration(label: 'Amount', hintText: '10000'),
            ),
          ),
          actions: [
            TextButton(
                onPressed: () {
              
                if (_amountFormKey.currentState!.validate()) {
                  setState(() {
                    amountToSpend = int.parse(_amountToSpendC.value.text);
                  });
                  _amountToSpendC.clear();
                  Navigator.pop(context);
                }
                },
                child: const Text(
                  'OKAY',
                  style: TextStyle(color: AppColors.themeColor),
                ))
          ],
        ),
      ),
    );
  }

  void hasViewedReverse() async {
    bool? hasSeen = await SharedPrefs().seenReverseMode();
    if (!hasSeen!) {
      Future.delayed(const Duration(seconds: 1), () {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Reverse mode feature'),
                  content: const Text(
                      'In reverse mode, you specify the amount of money you wish to spend and each expense added deducts its price from the specified amount.'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          SharedPrefs().setSeenReverseMode();
                          Navigator.pop(context);
                        },
                        child: const Text(
                          'OKAY',
                          style: TextStyle(color: AppColors.themeColor),
                        ))
                  ],
                ));
      });
    }
  }
}
