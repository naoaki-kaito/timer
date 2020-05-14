import 'package:shared_preferences/shared_preferences.dart';

class UserStore {
  static UserStore _store = UserStore._internal();
  factory UserStore() => _store;
  UserStore._internal();

  static String prefsKeyRepeat = 'repeat';
  SharedPreferences prefs;

  bool get repeat => prefs.getBool(UserStore.prefsKeyRepeat);
  set repeat(bool value) =>
      UserStore().prefs.setBool(UserStore.prefsKeyRepeat, value);

  static clearRepeat() {
    UserStore().repeat = false;
  }
}
