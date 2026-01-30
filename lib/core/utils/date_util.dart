
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtil {

  static bool isPastDate(DateTime date) {
    return date.millisecondsSinceEpoch < DateTime.now().millisecondsSinceEpoch;
  }


  static Future<DateTime?> getDateAndTime(DateTime selectedDate, BuildContext context) async {
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

  static Widget dayDateTimeText(DateTime date, BuildContext context) {
    final theme = Theme.of(context);
    String locale = Localizations.localeOf(context).languageCode;
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end, 
      children: [
        Text(
          DateFormat.yMMMd(locale).format(date),style: theme.textTheme.labelLarge,),
        Text(
          DateFormat.jm(locale).format(date),
          style: TextStyle(
            color: theme.textTheme.labelLarge!.color!.withAlpha(100),
            fontSize: theme.textTheme.labelSmall!.fontSize,
          ),
        ),
      ],
    );
  }
  static String formatMyDate(DateTime date, BuildContext context) {
  String locale = Localizations.localeOf(context).languageCode;

  return DateFormat.yMMMd(locale).format(date);
}
}
