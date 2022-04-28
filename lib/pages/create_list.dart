import 'dart:io';

import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/models/budget_plan.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/widgets/share_type.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
  final FocusNode _focusNode = FocusNode();

  final _formKey = GlobalKey<FormState>();

  List<Expense> expenses = [];

  @override
  void initState() {
    super.initState();
    expenses.addAll(widget.expenses!);

    _quantityC.text = '1';
  }

  int get _total {
    int sum = 0;
    for (Expense val in expenses) {
      sum += val.quantity * val.price;
    }
    return sum;
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
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          leading: Container(),
          toolbarHeight: AppSizes.midToolBarHeight,
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
                      widget.title ?? 'Quick Budget',
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ksh.' + _total.toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40.sp,
                          fontWeight: FontWeight.bold),
                    )
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
                            ' unit(s) @ ksh.' +
                            expenses[index].price.toString()),
                        trailing: Text(
                          'ksh.' +
                              (expenses[index].quantity * expenses[index].price)
                                  .toString(),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    );
                  }),
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
          onPressed: () async {
            if (widget.title != null) {
              Navigator.pop(context, {'expenses': expenses, 'total': _total});
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
                    title: 'Quick Budget List',
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
            }
          },
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
}
