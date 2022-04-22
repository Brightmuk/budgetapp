
import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';



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
                        cursorColor: AppColors.themeColor,
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
                                color: AppColors.themeColor,
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
                                color: AppColors.themeColor,
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
                          cursorColor: AppColors.themeColor,
                          decoration: InputDecoration(
                            label: const Padding(
                              padding: EdgeInsets.only(left: 8.0),
                              child: Text('Price',
                                  style: TextStyle(color: Colors.white)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: const BorderSide(
                                  color: AppColors.themeColor,
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
                                  color: AppColors.themeColor,
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
                            primary: AppColors.themeColor, // header background color
                          ),
                          textButtonTheme: TextButtonThemeData(
                            style: TextButton.styleFrom(
                              primary: AppColors.themeColor,
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
                  activeColor: AppColors.themeColor,
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
                  color: AppColors.themeColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50)),
                  child: const Text(
                    'Save',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                     Navigator.pop(context);
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const SingleWish()));
                  }),
            ),
          ],
        ),
      ),
    );
  }
}