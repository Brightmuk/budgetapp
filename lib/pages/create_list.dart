import 'dart:io';

import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:budgetapp/widgets/share_type.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';

class CreateList extends StatefulWidget {
  final String? title;
  const CreateList({Key? key, this.title}) : super(key: key);

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
    _quantityC.text = '1';
  }

  String get total {
    int sum = 0;
    for (Expense val in expenses) {
      sum += val.quantity * val.price;
    }
    return sum.toString();
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
                  cursorColor: const Color.fromRGBO(72, 191, 132, 1),
                  decoration: InputDecoration(
                    label: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Item name',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(72, 191, 132, 1), width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(72, 191, 132, 1), width: 1.5),
                    ),
                    hintText: 'Food',
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'The name is required';
                    }
                  },
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  controller: _quantityC,
                  cursorColor: const Color.fromRGBO(72, 191, 132, 1),
                  decoration: InputDecoration(
                    label: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Quantity',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(72, 191, 132, 1), width: 1.5),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(
                          color: Color.fromRGBO(72, 191, 132, 1), width: 1.5),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.2,
                child: TextFormField(
                    keyboardType: TextInputType.number,
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
                    cursorColor: const Color.fromRGBO(72, 191, 132, 1),
                    decoration: InputDecoration(
                      label: const Padding(
                        padding: EdgeInsets.only(left: 8.0),
                        child: Text(
                          'Price',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(72, 191, 132, 1), width: 1.5),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
                      ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(217, 4, 41, 1), width: 1.5),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color.fromRGBO(72, 191, 132, 1), width: 1.5),
                      ),
                      hintText: '300.00',
                    ),
                    validator: (val) {
                      if (val!.isEmpty) {
                        return 'The price is required';
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
          toolbarHeight: 140,
          flexibleSpace: AnimatedContainer(
            padding: const EdgeInsets.all(15),
            duration: const Duration(seconds: 2),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Color.fromRGBO(72, 191, 132, 1),
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
                      style: const TextStyle(
                          fontSize: 15, fontWeight: FontWeight.bold),
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
                    const Text(
                      'Total',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'ksh.' + total,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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
                      key: Key(index.toString()),
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
            const SizedBox(
              height: 30,
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'Share',
          backgroundColor: const Color.fromRGBO(
            72,
            191,
            132,
            1,
          ),
          onPressed: () async {
            if (widget.title != null) {
              Navigator.pop(context, expenses);
            } else {
              bool asPdf = await showModalBottomSheet(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  context: context,
                  builder: (context) => const ShareType());
              if (asPdf) {
                File pdf = await PDFService.createPdf('new');
                await Printing.sharePdf(
                    bytes: pdf.readAsBytesSync(), filename: 'my-document.pdf');
              }
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
            widget.title != null ? 'Save' : 'Share',
            style: const TextStyle(color: Colors.white),
          ),
          icon: widget.title != null
              ? null
              : const Icon(
                  Icons.receipt_outlined,
                  color: Colors.white,
                ),
        ),
      ),
    );
  }
}
