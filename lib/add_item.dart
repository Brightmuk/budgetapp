import 'package:budgetapp/export_view.dart';
import 'package:budgetapp/item_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class ItemType extends StatelessWidget {
  const ItemType({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 200,
        child: ListView(
          children: [
            const Text(
              'Select type',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.pinkAccent,
                    ),
                    height: 10,
                    width: 10),
              ),
              title: const Text('Budget Plan'),
              subtitle: const Text('A plan to spend an amount of money'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) => const AddBudgetPlan());
              },
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      color: Colors.orangeAccent,
                    ),
                    height: 10,
                    width: 10),
              ),
              title: const Text('Wish'),
              subtitle: const Text(
                  'Something that you plan to buy, will be added to your wishlist'),
              onTap: () {
                Navigator.pop(context);
                showModalBottomSheet(
                    isScrollControlled: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    context: context,
                    builder: (context) => const AddWish());
              },
            ),
          ],
        ),
      ),
    );
  }
}

class AddWish extends StatefulWidget {
  const AddWish({
    Key? key,
  }) : super(key: key);

  @override
  _AddWishState createState() => _AddWishState();
}

class _AddWishState extends State<AddWish> {
  final DateFormat dayDate = DateFormat('EEE dd, yyy');
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  late DateTime _selectedDate = DateTime.now();
  late bool remider = true;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Stack(
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Add a new Wish',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear_outlined))
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Form(
                key: _formKey,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextFormField(
                        controller: _nameC,
                        cursorColor: const Color.fromRGBO(72, 191, 132, 1),
                        decoration: InputDecoration(
                          label: const Padding(
                            padding: EdgeInsets.only(left: 8.0),
                            child: Text(
                              'Name',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(72, 191, 132, 1),
                                width: 1.5),
                          ),
                          errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(217, 4, 41, 1),
                                width: 1.5),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(217, 4, 41, 1),
                                width: 1.5),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(
                                color: Color.fromRGBO(72, 191, 132, 1),
                                width: 1.5),
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
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: TextFormField(
                          keyboardType: TextInputType.number,
                          controller: _priceC,
                          cursorColor: const Color.fromRGBO(72, 191, 132, 1),
                          decoration: InputDecoration(
                            label: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Price',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(72, 191, 132, 1),
                                  width: 1.5),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(217, 4, 41, 1),
                                  width: 1.5),
                            ),
                            errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(217, 4, 41, 1),
                                  width: 1.5),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: Color.fromRGBO(72, 191, 132, 1),
                                  width: 1.5),
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
              const SizedBox(
                height: 20,
              ),
              ListTile(
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
                            primary: Color.fromRGBO(
                                72, 191, 132, 1), // header background color
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
              const Divider(),
              CheckboxListTile(
                  activeColor: const Color.fromRGBO(72, 191, 132, 1),
                  value: remider,
                  title: const Text('Set reminder on'),
                  onChanged: (val) {
                    setState(() {
                      remider = val!;
                    });
                  })
            ]),
            Positioned(
              bottom: 10,
              child: MaterialButton(
                  padding: const EdgeInsets.all(20),
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  color: const Color.fromRGBO(72, 191, 132, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {

                  }),
            ),
          ],
        ),
      ),
    );
  }
}

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

  List<Item> items = [];

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
                  const Text(
                    'Add a new Budget plan',
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(Icons.clear_outlined))
                ],
              ),
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
              const SizedBox(
                height: 20,
              ),
              ListTile(
                title: const Text('Edit list'),
                subtitle: Text('${items.length} item(s) in list'),
                trailing: const Text(
                  'Ksh.23,000',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                onTap: () async {
                  var result =
                      await Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => BudgetLists(
                                title: _titleC.value.text,
                              )));
                  setState(() {
                    items = result;
                  });
                },
              ),
              Divider(),
              ListTile(
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
              CheckboxListTile(
                  activeColor: Colors.greenAccent,
                  value: save,
                  title: const Text('Export'),
                  subtitle: Text(
                      'Export list as ${exportAsPdf ? 'PDF' : 'Image'}  after saving'),
                  onChanged: (val) async {
                    setState(() {
                      save = val!;
                    });
                    if(val!){
                    var result = await showModalBottomSheet(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        context: context,
                        builder: (context) => const ExportType());
                    if (result != null) {
                      setState(() {
                         exportAsPdf = result;
                      });
                    }
                    }

                  }),
            ]),
            Positioned(
              bottom: 10,
              child: MaterialButton(
                  padding: const EdgeInsets.all(20),
                  minWidth: MediaQuery.of(context).size.width * 0.9,
                  color: const Color.fromRGBO(72, 191, 132, 1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                     Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const ExportPage(items: [])));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
