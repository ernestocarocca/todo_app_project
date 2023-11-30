// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:core';

import 'package:flutter/foundation.dart';

import 'package:shared_preferences/shared_preferences.dart';

class TodoItem {
   String title;
  List<String> todoList; // Listan av uppgifter
  bool isCrossed;
 String description;

  TodoItem(
    this.title,
    this.todoList,
    this.isCrossed,
    this.description,
  );

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'todoList': todoList,
      'isCrossed': isCrossed,
      'description': description,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      map['title'] as String, // Ange att 'title' är av typen String
      List<String>.from(map['todoList'] ??
          []), // Konvertera listan från dynamisk till en lista av strängar
      map['isCrossed'] as bool, // Ange att 'isCrossed' är av typen bool
      map['description'] as String, // Ange att 'description' är av typen String
    );
  }
}

class TodosManager {
  static late SharedPreferences _prefs;
  static const _keyTodo = 'Todo';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialiserades');
  }

  Future<void> addTodoList(List<TodoItem> todoList) async {
    final List<String> todos = _prefs.getStringList(_keyTodo) ?? [];

    for (TodoItem todo in todoList) {
      todos.add(json.encode(todo.toJson()));
      debugPrint(todos.last.toString());
    }

    await _prefs.setStringList(_keyTodo, todos);
  }

Future<void> removeTodos(List<TodoItem> todosToRemove) async {
  List<String> todos = _prefs.getStringList(_keyTodo) ?? [];

  todos.removeWhere((taskJson) {
    final todoData = json.decode(taskJson);
    final existingTodo = TodoItem.fromMap(todoData);

    return todosToRemove.any((todo) => _isMatchingTodoItem(existingTodo, todo));
  });

  await _prefs.setStringList(_keyTodo, todos);
}

bool _isMatchingTodoItem(TodoItem existingTodo, TodoItem todoToRemove) {
  return existingTodo.title == todoToRemove.title &&
      existingTodo.description == todoToRemove.description &&
      existingTodo.isCrossed == todoToRemove.isCrossed &&
      existingTodo.todoList.length == todoToRemove.todoList.length &&
      existingTodo.todoList.every((element) => todoToRemove.todoList.contains(element));
}

  Future<List<TodoItem>> getTodos() async {
    if (!_prefs.containsKey(_keyTodo)) {
      return []; // Returnera tom lista om det inte finns några sparade uppgifter
    }
    final List<String> todos = _prefs.getStringList(_keyTodo) ?? [];
    List<TodoItem> todoItems = [];
    if (todos == null || todos.isEmpty) {
      return []; // Returnera tom lista om sparade uppgifter är null eller tomma
    }
    for (String todoJson in todos) {
      try {
        final Map<String, dynamic> todoData = json.decode(todoJson);

        // Kolla om strukturen är för det nya TodoItem-formatet med en lista av uppgifter
        if (todoData.containsKey('title') &&
            todoData.containsKey('todoList') &&
            todoData.containsKey('isCrossed') &&
            todoData.containsKey('description')) {
          final TodoItem todoItem = TodoItem.fromMap(todoData);
          todoItems.add(todoItem);
        }
      } catch (e) {
        print('Fel vid avkodning av TodoItem: $e');
      }
    }

    return todoItems;
  }
}
