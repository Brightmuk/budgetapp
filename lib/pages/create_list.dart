import 'dart:io';

import 'package:admob_flutter/admob_flutter.dart';
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/formatters.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/services/shared_prefs.dart';
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

  List<Expense> expenses = [];
  bool reverseMode = false;
  int amountToSpend = 0;

  late AdmobInterstitial interstitialAd;

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

  @override
  void initState() {
    super.initState();
    hasViewedReverse();

    expenses.addAll(widget.expenses!);

    _quantityC.text = '1';

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
    final AppState _appState = Provider.of<AppState>(context);

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
                          fontSize: 40.sp, fontWeight: FontWeight.bold),
                    ),
                    IconButton(
                      icon: const Icon(Icons.clear_outlined),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ],
                ),
                const Divider(
                  height: 5,
                ),
                Row(
                  children: [
                    const Text('Reverse Mode'),
                    Switch(
                        value: reverseMode,
                        onChanged: (val) {
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
                        }),
                  ],
                ),
                const Divider(
                  height: 5,
                ),
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
                        child: Row(
                          children: const [
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
                        subtitle: Text(expenses[index].quantity.toString() +
                            ' unit(s) @' +
                            AppFormatters.moneyCommaStr(expenses[index].price) +
                            ' ${_appState.currentCurrency} '),
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
              height: 150.sp,
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
                    // bool asPdf = await showModalBottomSheet(
                    //     shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)),
                    //     context: context,
                    //     builder: (context) => const ShareType());
                    // if (asPdf) {
                    SpendingPlan plan = SpendingPlan(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        total: _total,
                        title: 'Quick Spending Plan',
                        creationDate: DateTime.now(),
                        reminderDate: DateTime.now(),
                        reminder: false,
                        expenses: expenses);
                    File pdf = await PDFService.createPdf(plan);
                    await Printing.sharePdf(
                        bytes: pdf.readAsBytesSync(),
                        filename: '${plan.title}.pdf');
                    // }
                    // } else {
                    //   File pdf = await PDFService.createPdf('new');
                    //   await for (var page in Printing.raster(pdf.readAsBytesSync(),
                    //       pages: [0, 1], dpi: 72)) {
                    //     final image = await page.toImage();
                    //     image.toByteData();
                    //   }

                    //   await Printing.sharePdf(
                    //       bytes: pdf.readAsBytesSync(), filename: 'my-document.pdf');
                    // }
                    if (!_appState.adShown) {
                      interstitialAd.show();
                      _appState.changeAdView();
                    } else {
                      _appState.changeAdView();
                    }
                  }
                }
              : null,
          tooltip: 'Share',
          label: Text(
            widget.title != null ? 'Done' : 'Share',
            style: TextStyle(color: Colors.white, fontSize: 35.sp),
          ),
          icon: widget.title != null
              ? Icon(
                  Icons.done,
                  color: Colors.white,
                  size: 50.sp,
                )
              : Icon(
                  Icons.receipt_outlined,
                  color: Colors.white,
                  size: 50.sp,
                ),
        ),
      ),
    );
  }

  Widget expense() => Padding(
        padding: const EdgeInsets.all(8.0),
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
                    }
                  },
                  decoration: AppStyles()
                      .textFieldDecoration(label: 'Name', hintText: 'Food'),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'Name is required';
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextFormField(
                  keyboardType: TextInputType.number,
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
          content: TextFormField(
            keyboardType: TextInputType.number,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            controller: _amountToSpendC,
            onFieldSubmitted: (val) {
              setState(() {
                amountToSpend = int.parse(val);
              });
              _amountToSpendC.clear();
              Navigator.pop(context);
            },
            cursorColor: AppColors.themeColor,
            decoration: AppStyles()
                .textFieldDecoration(label: 'Amount', hintText: '10000'),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  setState(() {
                    amountToSpend = int.parse(_amountToSpendC.value.text);
                  });
                  _amountToSpendC.clear();
                  Navigator.pop(context);
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
}
