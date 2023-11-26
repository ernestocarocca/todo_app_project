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




class InProgressItem {
  final String title;
  final String description;

  InProgressItem({required this.title, required this.description});
}

class InProgressModel extends ChangeNotifier {
  final List<InProgressItem> _inProgressList = [];

  List<InProgressItem> get inProgressList => _inProgressList;

  void addTodoItem(InProgressItem inprogressItem) {
    _inProgressList.add(inprogressItem);
    notifyListeners();
  }

  void addInProgressItems(List<InProgressItem> inprogressItems) {
    _inProgressList.addAll(inprogressItems);
    notifyListeners();
  }
}


class DoneItem {
  final String title;
  final String description;

  DoneItem({required this.title, required this.description});
}

class DoneModel extends ChangeNotifier {
  final List<DoneItem> _doneList = [];

  List<DoneItem> get doneList => _doneList;

  void addDoneItem(DoneItem doneItem) {
    _doneList.add(doneItem);
    notifyListeners();
  }

  void addDoneItems(List<DoneItem> doneItems) {
    _doneList.addAll(doneItems);
    notifyListeners();
  }
}

