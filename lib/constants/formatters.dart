import 'package:flutter/services.dart';

class AppFormatters{

  var numberInputFormatters = [FilteringTextInputFormatter.allow(RegExp("[0-9]")), LengthLimitingTextInputFormatter(12),];

  // String moneyFormatter(int amount){
  //   if(amount.toString().length>)
  // }
  
}