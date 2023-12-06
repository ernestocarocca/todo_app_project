import 'package:flutter/material.dart';

class ToDoItemModel {
  final String title;
  final String description;
  final String imageUrl;

  ToDoItemModel(
      {required this.title, required this.description, required this.imageUrl});
}

class ToDoModel extends ChangeNotifier {
  final List<ToDoItemModel> _toDoList = [];

  List<ToDoItemModel> get toDoList => _toDoList;

  void addTodoItem(ToDoItemModel todoItem) {
    _toDoList.add(todoItem);
    // notifyListeners();
  }

  void addTodoItems(List<ToDoItemModel> todoItems) {
    _toDoList.addAll(todoItems);
    //notifyListeners();
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
    //   notifyListeners();
  }

  void addInProgressItems(List<InProgressItem> inprogressItems) {
    _inProgressList.addAll(inprogressItems);
    // notifyListeners(); Ernesto: gör så appen krashar måste hanteras
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
  }
}
