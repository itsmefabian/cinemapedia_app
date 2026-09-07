import 'package:intl/intl.dart';

class Formats {
  static String number(double number, [int decimals = 0]) {
    final finalFormat = NumberFormat.compact(locale: 'en_US')
      ..maximumFractionDigits = decimals;

    return finalFormat.format(number);
  }
}
