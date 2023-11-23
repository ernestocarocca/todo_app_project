// ignore_for_file: unused_element

import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesManager {
  static late SharedPreferences _preferences;
  static const _keyInputName = 'inputesName';
  static const _keysTodos = 'todos';
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get preferences {
    return _preferences;
  }

  static Future setNames(String names) async =>
      await _preferences.setString(_keyInputName, names);
  static getNames() => _preferences.getString(_keyInputName);

  static Future setTodos(List<String> todoList) async =>
      await _preferences.setStringList(_keysTodos, todoList);
  static List<String>? getTodos(List<String> getTodoList) => _preferences.getStringList(_keysTodos);
}
