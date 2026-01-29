import 'package:budgetapp/core/sizes.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DateUtil {
  final BuildContext context;

  DateUtil({required this.context});

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
    );
    if (dateResult != null) {
      timeResult = await showTimePicker(
        context: context,
        initialTime:
            TimeOfDay(hour: selectedDate.hour, minute: selectedDate.minute),
      );
    }
    if (timeResult == null || dateResult == null) return null;
    return DateTime(dateResult.year, dateResult.month, dateResult.day,
        timeResult.hour, timeResult.minute);
  }

  Widget dayDateTimeText(DateTime date) {
    final theme = Theme.of(context);
    return RichText(
      text: TextSpan(children: [
        TextSpan(
          text: dayDate.format(date),
          style: TextStyle(
            color: theme.textTheme.bodyMedium!.color,
          ),
        ),
        TextSpan(
          text: ' ${time.format(date)}',
          style: TextStyle( color: theme.textTheme.labelLarge!.color!.withAlpha(100)),
        ),
      ]),
    );
  }
}
