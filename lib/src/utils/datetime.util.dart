import 'package:intl/intl.dart';

const locale = 'en';
String formatDateTime(DateTime? s) {
  if (s == null) return '';
  return DateFormat('EEEE dd-MM-yyyy HH:mm').format(s);
}

String formatDate(DateTime? s) {
  if (s == null) return '';
  return DateFormat('yyyy-MM-dd').format(s);
}


String formatDateTimeFromString(String? s) {
  if (s == null) return '';
  DateTime tempDate = new DateFormat("yyyy-MM-dd hh:mm:ss").parse(s);
  return DateFormat('EEEE dd-MM-yyyy HH:mm').format(tempDate);
}
