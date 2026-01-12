import 'package:intl/intl.dart';

final _formatter = NumberFormat('#,##0', 'ru_RU');

String formatNumber(double number) {
  return _formatter.format(number.toInt());
}