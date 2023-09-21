import 'package:intl/intl.dart';

const locale = 'en';
String formatDateTime(DateTime s) {
  return DateFormat('dd-MM-yyyy HH:mm').format(s);
}
