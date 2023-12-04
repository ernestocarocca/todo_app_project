
import 'dart:convert';
import 'dart:core';
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

  void addTask(String taskName) {
    todoList.add(TodoTask(taskName: taskName));
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
    return TodoItem(
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
  TodoTask({
    required this.taskName,
  }) : taskId = _taskCounter++;
  Map<String, dynamic> toJson() {
    return {'id': taskId, 'taskName': taskName};
  }

  factory TodoTask.fromJson(Map<String, dynamic> map) {
    return TodoTask(
      taskName: map['taskName'],
    );
  }

  @override
  String toString() {
    return " id:$taskId, taskName:  $taskName ";
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
    List<String> todos = _prefs.getStringList(_keyTodo) ?? [];
    print(todos);
    for (TodoItem todo in todoList) {
      final encodedTodo = json.encode(todo.toJson());

      todos.add(encodedTodo);
    }
    print(todos);
    await _prefs.setStringList(_keyTodo, todos);
  }

  Future<void> removeTodos(List<TodoItem> todosToRemove) async {
    List<String> todos = _prefs.getStringList(_keyTodo) ?? [];
    print(' removeTodo: todos  $todos');
    todos.removeWhere((taskJson) {
      final todoData = json.decode(taskJson);
      print(' removeTodo: tdodoData  ${todoData.runtimeType}');
      final existingTodo = TodoItem.fromJson(todoData);
      print(' removeTodo: existingTodo  $existingTodo');

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
