import 'package:intl/intl.dart';

class Formats {
  static String number(double number) {
    return NumberFormat.compact(locale: 'en').format(number);
  }
}
