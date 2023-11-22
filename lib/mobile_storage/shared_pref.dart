import 'dart:core';
import 'package:flutter/material.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
//import 'package:todo_app_project/main.dart';¨

class TextFieldScreen extends StatefulWidget {
  const TextFieldScreen({super.key});

  @override
  _TextFieldState createState() => _TextFieldState();
}

class _TextFieldState extends State<TextFieldScreen> {
  final TextEditingController textController = TextEditingController();
  String name = '';
  String enteredText = '';
  // List<String> getNames = [];
  @override
  void initState() {
    super.initState();
    enteredText = SharedPreferencesManager.getNames() ?? '';
    //loadSavedTime();
  }

  /*

  void saveName() async {
    SharedPreferences prefs = SharedPreferencesManager._preferences;

    List<String> savedNames = .map((getN) {
    
      return 
    }).toList();
    await prefs.setStringList('savedTimes', timeStrings);

    setState(() {});
  }
*/

/*
  void addName() async {
    // saves data in device ?
    SharedPreferences prefs = SharedPreferencesManager._preferences;

    List<String> inputNames = [];
    inputNames.add(enteredText);

    prefs.setStringList('name', inputNames);
  } */

  /* void loadSavedTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? names = prefs.getStringList('name');
getNames = names.map((names)) =>  return names;
 
    for (String n in names) {
      names.add(n);
      print('här loadar jag datan : $n');
    }

    prefs.getStringList('name');
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TextField Screen'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            TextField(
              controller: textController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                await SharedPreferencesManager.setNames(textController.text);
                enteredText = await SharedPreferencesManager.getNames();
                print(' funkar stort : $enteredText');
              },
              child: Text('Spara'),
            ),
          ],
        ),
      ),
    );
  }
}

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
