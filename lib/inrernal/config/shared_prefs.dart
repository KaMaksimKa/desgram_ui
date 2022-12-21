import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _currentUserIdKey = "currentIdUserKey";

  static Future<String?> getCurrentUserId() async {
    var sharedPref = await SharedPreferences.getInstance();
    return sharedPref.getString(_currentUserIdKey);
  }

  static Future setCurrentUserId(String? userId) async {
    var sharedPref = await SharedPreferences.getInstance();
    if (userId == null) {
      await sharedPref.remove(_currentUserIdKey);
    } else {
      await sharedPref.setString(_currentUserIdKey, userId);
    }
  }
}
