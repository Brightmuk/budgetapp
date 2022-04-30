import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/formatters.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:budgetapp/constants/style.dart';
import 'package:budgetapp/models/wish.dart';
import 'package:budgetapp/pages/single_wish.dart';
import 'package:budgetapp/providers/app_state_provider.dart';
import 'package:budgetapp/services/date_services.dart';
import 'package:budgetapp/services/notification_service.dart';
import 'package:budgetapp/services/toast_service.dart';
import 'package:budgetapp/services/wish_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;

class AddWish extends StatefulWidget {
  final Wish? wish;
  const AddWish({Key? key, this.wish}) : super(key: key);

  @override
  _AddWishState createState() => _AddWishState();
}

class _AddWishState extends State<AddWish> {
  final TextEditingController _nameC = TextEditingController();
  final TextEditingController _priceC = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final FocusNode _focusNode = FocusNode();
  final FocusNode _focusNode2 = FocusNode();
  bool editMode = false;

  late DateTime _selectedDate = DateTime.now().add(const Duration(hours: 1));
  late bool reminder = false;
  @override
  void initState() {
    super.initState();
    editMode = widget.wish != null;
    if (widget.wish != null) {
      reminder = widget.wish!.reminder;
      _selectedDate = widget.wish!.reminderDate;
      _nameC.text = widget.wish!.name;
      _priceC.text = widget.wish!.price.toString();
    }
  }

  @override
  Widget build(BuildContext context) {
        final AppState _appState = Provider.of<AppState>(context);
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.5,
      child: Padding(
        padding: EdgeInsets.all(AppSizes.pagePading.sp),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    editMode ? 'Edt wish' : 'Add a new Wish',
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
                        focusNode: _focusNode,
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
                          focusNode: _focusNode2,
                          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
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
              const Divider(),
               CheckboxListTile(
                  activeColor: Colors.greenAccent,
                  value: reminder,
                  title: Text('Set reminder on',
                      style: TextStyle(fontSize: 35.sp)),
                  subtitle: Text('You will be reminded to fullfil the wish',
                      style: TextStyle(fontSize: 35.sp)),
                  onChanged: (val) {
                    _focusNode.unfocus();
                    _focusNode2.unfocus();
                    setState(() {
                      reminder = val!;
                    });
                  }),
              Opacity(
                opacity: reminder?1:0.5,
                child: ListTile(
                  leading: Icon(
                    Icons.calendar_month_outlined,
                    size: AppSizes.iconSize.sp,
                  ),
                  title: Text(
                    'Reminder date',
                    style: TextStyle(fontSize: AppSizes.normalFontSize.sp),
                  ),
                  trailing: DateServices(context: context)
                      .dayDateTimeText(_selectedDate),
                  onTap: reminder?() async {
                    _focusNode.unfocus();
                    _focusNode2.unfocus();
                          var now =
                              DateTime.now();
                          final dateResult =
                              await DateServices(context: context)
                                  .getDateAndTime(_selectedDate);
                          if (dateResult != null&&dateResult.millisecondsSinceEpoch >
                              now.millisecondsSinceEpoch) {
                            setState(() {
                              _selectedDate = dateResult;
                            });
                          } else if (dateResult!.millisecondsSinceEpoch <
                              now.millisecondsSinceEpoch) {
                            ToastService(context: context).showSuccessToast(
                                'Reminders can only be set an hour from now');
                          }
                  }:null,
                ),
              ),


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
                      try {
                        String id =
                            DateTime.now().millisecondsSinceEpoch.toString();
                        Wish wish = Wish(
                          ////If in edit mode use the items id and not new one
                          id: editMode ? widget.wish!.id : id,
                          price: int.parse(_priceC.value.text),
                          reminderDate: _selectedDate,
                          creationDate: DateTime.now(),
                          name: _nameC.value.text,
                          reminder: reminder,
                        );
                        await WishService(context: context,appState: _appState)
                            .saveWish(wish: wish)
                            .then((value) async {
                          if (value) {
                            ///only set reminder when user selects it
                            if (wish.reminder) {
                              await NotificationService().zonedScheduleNotification(
                                  id: int.parse(wish.id.substring(8)),
                                  payload: '{"itemId":$id,"route":"/singlewish"}',
                                  title: 'Wish fulfilment',
                                  description:
                                      'Remember to purchase your ${wish.name} Buddy!',
                                  scheduling:
                                      tz.TZDateTime.fromMillisecondsSinceEpoch(
                                          tz.local,
                                          wish.reminderDate
                                              .millisecondsSinceEpoch));
                            } else {
                              ///Delete in case they are editing and seting reminder off
                              await NotificationService().removeReminder(int.parse(wish.id.substring(8)));
                            }

                            ////If in edit mode pop twice
                            if (editMode) {
                              Navigator.pop(context);
                            }

                            Navigator.pop(context);
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) =>
                                    ////If in edit mode use the items id and not new one
                                    SingleWish(
                                      wishId: editMode ? widget.wish!.id : id,
                                    )));
                          }
                        });
                      } catch (e) {
                        ToastService(context: context)
                            .showSuccessToast('Sorry, there was an error');
                      }
                    }
                  }),
            ),
          ],
        ),
      ),
    );
  }
}
