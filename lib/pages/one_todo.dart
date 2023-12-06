// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

// ignore: must_be_immutable
class ToDoDetailsPage extends StatefulWidget {
  final TodoItem todoItem;
  String image;
  ToDoDetailsPage({
    Key? key,
    required this.todoItem,
    required this.image,
  }) : super(key: key);

  @override
  ToDoDetailsPageState createState() => ToDoDetailsPageState();
}

class ToDoDetailsPageState extends State<ToDoDetailsPage> {
  TodosManager todosManager = TodosManager();

  @override
  void initState() {
    super.initState();
    // Initialize the list with the completion status of each task
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('ToDo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${widget.todoItem.title}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            Text(
              'Status: ${widget.todoItem.isCrossed ? 'Completed' : 'Incomplete'}',
              style: TextStyle(
                color: widget.todoItem.isCrossed ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 16.0),
            
            widget.image != null
                ? Image.file(
                    File(widget.image),
                    height: 90,
                    width: 90,
                  )
                :  SizedBox(
                    height: 90.0,
                    width: 90.0,
                    child: Icon(Icons.image_aspect_ratio)),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.todoItem.todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: Checkbox(
                    value: widget.todoItem.todoList[index].isDone,
                    onChanged: (value) {
                      setState(() {
                        // Toggle the completion status of the task

                        widget.todoItem.todoList[index].isDone = value!;
                        // Handle your logic for overall task completion here

                        if (widget.todoItem.todoList
                            .map((task) => task.isDone)
                            .toList()
                            .contains(!true)) {
                          widget.todoItem.isCrossed = false;
                        } else {
                          widget.todoItem.isCrossed = true;
                        }
                        print(widget.todoItem);

                        updateTodo(widget.todoItem);
                      });
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                  ),
                  title: Text(widget.todoItem.todoList[index].taskName),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> saveTodos(List<TodoItem> todoItems) async {
    await todosManager.addTodoList(todoItems);
  }

  Future<void> updateTodo(TodoItem todo) async {
    await todosManager.updateTodo(todo);
  }
}
