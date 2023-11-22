import 'dart:core';

import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';


class SharedPreferencesManager {
  static late SharedPreferences _preferences;
  static const _keyInputName = 'inputesName';
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get preferences {
    return _preferences;
  }

  static Future setNames(String names) async =>
      await _preferences.setString(_keyInputName, names);
  static getNames() => _preferences.getString(_keyInputName);
}
