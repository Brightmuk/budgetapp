import 'package:flutter/services.dart';

class InputFormatters{

  var numberInputFormatters = [FilteringTextInputFormatter.allow(RegExp("[0-9]")), LengthLimitingTextInputFormatter(12),];
  
}