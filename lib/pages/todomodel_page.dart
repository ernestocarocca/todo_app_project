import 'package:flutter/material.dart';


class ToDoItem {
  final String title;
  final String description;

  ToDoItem({required this.title, required this.description});
}

class ToDoModel extends ChangeNotifier {
  final List<ToDoItem> _toDoList = [];

  List<ToDoItem> get toDoList => _toDoList;

  void addTodoItem(ToDoItem todoItem) {
    _toDoList.add(todoItem);
    notifyListeners();
  }

  void addTodoItems(List<ToDoItem> todoItems) {
    _toDoList.addAll(todoItems);
    notifyListeners();
  }
}

