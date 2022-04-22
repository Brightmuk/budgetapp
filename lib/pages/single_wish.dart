import 'dart:io';

import 'package:budgetapp/pages/create_list.dart';
import 'package:budgetapp/models/expense.dart';
import 'package:budgetapp/services/pdf_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';

class SingleWish extends StatefulWidget {
  const SingleWish({
    Key? key,
  }) : super(key: key);

  @override
  _SingleWishState createState() => _SingleWishState();
}

class _SingleWishState extends State<SingleWish> {
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
          toolbarHeight: 120,
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
                    const Text(
                      'Air Jordans 4 retro',
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
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _titleC,
                  cursorColor: const Color.fromRGBO(72, 191, 132, 1),
                  decoration: InputDecoration(
                    label: const Padding(
                      padding: EdgeInsets.only(left: 8.0),
                      child: Text(
                        'Title',
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
                    hintText: "John's Birthday",
                  ),
                  validator: (val) {
                    if (val!.isEmpty) {
                      return 'The title is required';
                    }
                  },
                ),
              ),
              SizedBox(height: 20,),
              Divider(),
              ListTile(
                contentPadding: EdgeInsets.zero,
                leading: const Icon(Icons.calendar_month_outlined),
                title: const Text('Select date'),
                trailing: Text(dayDate.format(_selectedDate)),
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
                            onSurface: Color.fromRGBO(72, 191, 132, 1),

                            primary: Color.fromRGBO(72, 191, 132, 1),
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
                contentPadding: EdgeInsets.zero,
                  activeColor: Colors.greenAccent,
                  value: remider,
                  title: const Text('Set reminder on'),
                  subtitle: const Text(
                      'You will be reminded to fullfil the budget list'),
                  onChanged: (val) {
                    setState(() {
                      remider = val!;
                    });
                  }),
            ]),
          ),
        ),
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(left: 25),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              FloatingActionButton.extended(
                heroTag: 'print',
                label: const Text(
                  'Delete',
                  style: TextStyle(color: Colors.white),
                ),
                icon: const Icon(Icons.delete_outline,color: Colors.white),
                onPressed: ()async {

                },
                backgroundColor: const Color.fromRGBO(72, 191, 132, 1),
              ),
              // FloatingActionButton.extended(
              //   heroTag: 'share',
              //   label: const Text(
              //     'Share',
              //     style: TextStyle(color: Colors.white),
              //   ),
              //   icon: const Icon(Icons.share_outlined, color: Colors.white),
              //   onPressed: () async {
              //     File pdf = await PDFService.createPdf('new');
              //     await Printing.sharePdf(
              //         bytes: pdf.readAsBytesSync(), filename: 'my-document.pdf');
              //   },
              //   backgroundColor: const Color.fromRGBO(72, 191, 132, 1),
              // ),
              // const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}
