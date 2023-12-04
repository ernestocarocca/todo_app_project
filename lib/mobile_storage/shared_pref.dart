import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class TodoItem {
  int id;
  String title;
  List<TodoTask> todoList; // Listan av uppgifter
  bool isCrossed;
  // String description;
  static int counter = 0;
  TodoItem({
    required this.title,
    required this.todoList,
    required this.isCrossed,

    //  required this.description,
  }) : id = counter++;
  TodoItem.fromId(
      {required this.title,
      required this.todoList,
      required this.isCrossed,
      required this.id});

  void addTask(String taskName, bool done) {
    todoList.add(TodoTask(taskName: taskName, isDone: done));
  }

  void removeTask(TodoTask task) {
    todoList.removeWhere((todo) => todo.taskId == todo.taskId);
    id = todoList.length;
  }

  String showTodoList() {
    String showTodo = '';
    for (TodoTask todo in todoList) {
      showTodo = showTodo + todo.taskName + ",";
    }

    return showTodo;
  }

  @override
  String toString() {
    return 'id:  $id ,title:  $title, todoList:  $todoList,  isCrossed:  $isCrossed';
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'todoList': todoList.map((task) => task.toJson()).toList(),
      'isCrossed': isCrossed,
      // ' description': description
    };
  }

  factory TodoItem.fromJson(Map<String, dynamic> map) {
    return TodoItem.fromId(
      id: map['id'],
      title: map['title'],
      todoList: (map['todoList'] as List<dynamic>)
          .map((task) => TodoTask.fromJson(task))
          .toList(), // Konvertera listan från dynamisk till en lista av strängar
      isCrossed:
          map['isCrossed'] as bool, // Ange att 'isCrossed' är av typen bool
      //   description: map['description'],
    );
  }
}

class TodoTask {
  static int _taskCounter = 0;
  int taskId;
  String taskName;
  bool isDone;
  TodoTask({
    required this.taskName,
    required this.isDone,
  }) : taskId = _taskCounter++;
  Map<String, dynamic> toJson() {
    return {'id': taskId, 'taskName': taskName, 'isDone': isDone};
  }

  factory TodoTask.fromJson(Map<String, dynamic> map) {
    return TodoTask(
      taskName: map['taskName'],
      isDone: map['isDone'],
    );
  }

  @override
  String toString() {
    return " id:$taskId, taskName:  $taskName, isDone:  $isDone";
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
    //List<String> todos = _prefs.getStringList(_keyTodo) ?? [];
List<String> temp = [];
    for (TodoItem todo in todoList) {
      final encodedTodo = json.encode(todo.toJson());
temp.add(encodedTodo);
    // todos.add(encodedTodo);
    }

    await _prefs.setStringList(_keyTodo, temp);
  }

  Future<void> updateTodo(TodoItem todo) async {
    List<String> todos = _prefs.getStringList(_keyTodo) ?? [];

    String encodedTodo = json.encode(todo.toJson());

    List<TodoItem> listTodos = [];
    for (String todoJson in todos) {
      try {
        final Map<String, dynamic> todoData = json.decode(todoJson);

        listTodos.add(TodoItem.fromJson(todoData));
      } catch (e) {
        print('Fel vid avkodning av TodoItem: $e');
      }
    }
    int updateIndex = 0;
    for (int i = 0; i < listTodos.length; i++) {
      if (todo.id == listTodos[i].id) {
        updateIndex = i;
      }
    }
    todos[updateIndex] = encodedTodo;
    await _prefs.setStringList(_keyTodo, todos);
  }

  Future<void> removeTodos(List<TodoItem> todosToRemove) async {
    List<String> todos = _prefs.getStringList(_keyTodo) ?? [];

    todos.removeWhere((taskJson) {
      final todoData = json.decode(taskJson);

      final existingTodo = TodoItem.fromJson(todoData);

      return todosToRemove
          .any((todo) => _isMatchingTodoItem(existingTodo, todo));
    });

    await _prefs.setStringList(_keyTodo, todos);
  }

  bool _isMatchingTodoItem(TodoItem existingTodo, TodoItem todoToRemove) {
    return existingTodo.title == todoToRemove.title &&
        existingTodo.isCrossed == todoToRemove.isCrossed &&
        existingTodo.todoList.length == todoToRemove.todoList.length &&
        existingTodo.todoList
            .every((element) => todoToRemove.todoList.contains(element));
  }

  Future<List<TodoItem>> getTodos() async {
    final List<String> todos = _prefs.getStringList(_keyTodo) ?? [];
    List<TodoItem> listTodos = [];
    for (String todoJson in todos) {
      try {
        final Map<String, dynamic> todoData = json.decode(todoJson);

        listTodos.add(TodoItem.fromJson(todoData));
      } catch (e) {
        print('Fel vid avkodning av TodoItem: $e');
      }
    }

    return listTodos;
  }
}
