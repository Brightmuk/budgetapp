import 'package:budgetapp/constants/colors.dart';
import 'package:budgetapp/constants/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateServices {
  final BuildContext context;

  DateServices({required this.context});

  static DateFormat dayDate = DateFormat('EEE dd, yyy');
  static DateFormat dayDateTime = DateFormat('EEE dd, yyy hh:mm');
  static DateFormat time = DateFormat('hh:mm');

  bool isPastDate(DateTime date) {
    return date.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch;
  }

  Future<DateTime?> getDateAndTime(DateTime selectedDate) async {
    DateTime? dateResult;
    TimeOfDay? timeResult;
    dateResult = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
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
    if (dateResult != null) {
      timeResult = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.dark(
                brightness: Brightness.dark,
                onSurface: AppColors.themeColor,
                background: Colors.grey[900]!,
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
    }

    return DateTime(dateResult!.year, dateResult.month, dateResult.day,
        timeResult!.hour, timeResult.minute);
  }

  Widget dayDateTimeText(DateTime date) {
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: dayDate.format(date),
          style: TextStyle(
            fontSize: AppSizes.normalFontSize.sp,
          ),
        ),
        TextSpan(
          text: ' ${time.format(date)}',
          style: TextStyle(
              fontSize: AppSizes.normalFontSize.sp, color: Colors.grey),
        ),
      ]),
    );
  }
}
