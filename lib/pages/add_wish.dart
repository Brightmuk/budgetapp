import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AddWish extends StatefulWidget {
  final Wish? wish;
  const AddWish({Key? key, this.wish}) : super(key: key);

  @override
  _AddWishState createState() => _AddWishState();
}

class _AddWishState extends State<AddWish> {
  final DateFormat dayDate = DateFormat('EEE dd, yyy');
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool editMode = false;

  late DateTime _selectedDate = DateTime.now();
  late bool remider = true;
  @override
  void initState() {
    super.initState();
    editMode = widget.wish != null;
    if (widget.wish != null) {
      remider = widget.wish!.reminder;
      _selectedDate = widget.wish!.date;
      _nameC.text = widget.wish!.name;
      _priceC.text = widget.wish!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.pagePading.sp),
        child: Stack(
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editMode? 'Edt wish' : 'Add a new Wish',
                    style: TextStyle(
                        fontSize: AppSizes.titleFont.sp,
                        fontWeight: FontWeight.bold),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width * 0.6,
                      child: TextFormField(
                        controller: _nameC,
                        cursorColor: AppColors.themeColor,
                        decoration: AppStyles().textFieldDecoration(
                            label: 'Name', hintText: 'Air Jordans'),
                        validator: (val) {
                          if (val!.isEmpty) {
                            return 'Name is required';
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
                          decoration: AppStyles().textFieldDecoration(
                              label: 'Price', hintText: '300'),
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
              const SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.calendar_month_outlined,
                  size: AppSizes.iconSize.sp,
                ),
                title: Text(
                  'Select date',
                  style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
                ),
                trailing: Text(
                  dayDate.format(_selectedDate),
                  style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
                ),
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
              const Divider(),
              CheckboxListTile(
                  activeColor: AppColors.themeColor,
                  value: remider,
                  title: Text(
                    'Set reminder on',
                    style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
                  ),
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
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      String id =
                          DateTime.now().millisecondsSinceEpoch.toString();
                      Wish wish = Wish(
                        ////If in edit mode use the items id and not new one
                        id: editMode? widget.wish!.id : id,
                        price: int.parse(_priceC.value.text),
                        date: _selectedDate,
                        name: _nameC.value.text,
                        reminder: remider,
                      );
                      await WishService(context: context)
                          .saveWish(wish: wish)
                          .then((value) {
                        if (value) {
                          ////If in edit mode pop twice
                          if (editMode) {
                            Navigator.pop(context);
                          }

                          Navigator.pop(context);
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  ////If in edit mode use the items id and not new one
                                  SingleWish(
                                    wishId: editMode
                                        ? widget.wish!.id
                                        : id,
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
