import 'package:flutter/services.dart';
import 'package:intl/intl.dart';


class AppFormatters {
  // Made static so you can use AppFormatters.numberInputFormatters in TextFields
  static List<TextInputFormatter> numberInputFormatters = [
    FilteringTextInputFormatter.allow(RegExp("[0-9]")),
    LengthLimitingTextInputFormatter(12),
  ];

  /// Formats numbers to compact versions: 1,000,000 -> 1M, 1,500 -> 1.5K
  static String moneyStr(num amount) {
    // If it's less than 1000, just return the number string
    if (amount < 1000) return amount.toString();
    
    // .compact() automatically handles K (thousands), M (millions), B (billions)
    final format = NumberFormat.compact(explicitSign: false);
    return format.format(amount);
  }

  /// Formats with commas but no decimals: 1,000,000
  static String moneyCommaStr(num amount) {
    final formatCurrency = NumberFormat.currency(symbol: '', decimalDigits: 0);
    return formatCurrency.format(amount);
  }
}