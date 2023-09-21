import 'package:intl/intl.dart';

const locale = 'en';
String formatNumber(String s) {
  try {
    final String res = NumberFormat.decimalPattern(locale).format(int.parse(s));
    print(res);
    return res;
  } catch (e) {
    print(e);
    return s;
  }
}

String trailingZero(double? num) {
  if (num == null) return '';

  RegExp regex = RegExp(r'([.]*0)(?!.*\d)');
  String s = num.toString().replaceAll(regex, '');
  return s;
}
