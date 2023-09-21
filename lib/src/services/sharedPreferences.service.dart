import 'package:shared_preferences/shared_preferences.dart';

saveStorage(data) async {
  SharedPreferences s_prefs = await SharedPreferences.getInstance();
  s_prefs.setString("rinWalletStorage", data);
}

getStorage() async {
  SharedPreferences s_prefs = await SharedPreferences.getInstance();
  return s_prefs.getString("rinWalletStorage");
}
