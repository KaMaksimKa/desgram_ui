import 'dart:convert';

import 'package:desgram_ui/domain/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefs {
  static const String _currentUserKey = "currentUserKey";

  static Future<UserModel?> getCurrentUser() async {
    var sharedPref = await SharedPreferences.getInstance();
    var userJsonString = sharedPref.getString(_currentUserKey);
    return (userJsonString == null || userJsonString == "")
        ? null
        : UserModel.fromJson(jsonDecode(userJsonString));
  }

  static Future setCurrentUser(UserModel? userModel) async {
    var sharedPref = await SharedPreferences.getInstance();
    if (userModel == null) {
      await sharedPref.remove(_currentUserKey);
    } else {
      await sharedPref.setString(
          _currentUserKey, jsonEncode(userModel.toJson()));
    }
  }
}
