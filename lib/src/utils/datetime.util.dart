import 'package:intl/intl.dart';

const locale = 'en';
String formatDateTime(DateTime? s) {
  if (s == null) return '';
  return DateFormat('dd-MM-yyyy HH:mm').format(s);
}
