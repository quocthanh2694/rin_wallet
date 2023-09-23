import 'package:intl/intl.dart';

const locale = 'en';
String formatDateTime(DateTime? s) {
  if (s == null) return '';
  return DateFormat('EEEE dd-MM-yyyy HH:mm').format(s);
}
