import 'package:shared_preferences/shared_preferences.dart' show SharedPreferences;

class SFHelper {
  // static late final SharedPreferencesAsync _prefs;
  //
  // SFHelper(SharedPreferencesAsync sf){
  //    _prefs = sf;
  // }

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static Future<String?> get(String key) async {
    return _prefs.getString(key);
  }

  static void set(String key, dynamic value) async {
    if(value is String){
      _prefs.setString(key, value);
    }else if(value is bool){
      _prefs.setBool(key, value);
    }
  }

  static void remove(String key) async {
    _prefs.remove(key);
  }
}