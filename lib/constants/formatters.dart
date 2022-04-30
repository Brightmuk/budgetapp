import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class AppFormatters{

  var numberInputFormatters = [FilteringTextInputFormatter.allow(RegExp("[0-9]")), LengthLimitingTextInputFormatter(12),];

  static String moneyStr(int amount){
    final formatCurrency = NumberFormat.compactCurrency(symbol: '');
     return formatCurrency.format(amount);
  }

  static String moneyCommaStr(int amount){
    final formatCurrency = NumberFormat.currency(symbol: '',decimalDigits: 0);
     return formatCurrency.format(amount);
  }

  
}