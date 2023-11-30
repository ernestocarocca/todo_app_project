// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class ToDoDetailsPage extends StatefulWidget {
  final TodoItem todoItem;
  const ToDoDetailsPage({
    Key? key,
    required this.todoItem,
  }) : super(key: key);
  @override
  _ToDoDetailsPageState createState() => _ToDoDetailsPageState();
}

class _ToDoDetailsPageState extends State<ToDoDetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ToDo Details'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Title: ${widget.todoItem.title}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text(
              'Status: ${widget.todoItem.isCrossed ? 'Completed' : 'Incomplete'}',
              style: TextStyle(
                  color: widget.todoItem.isCrossed ? Colors.green : Colors.red),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.todoItem.todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  trailing: Checkbox(
                    value: widget.todoItem.isCrossed,
                    onChanged: (value) {
                      setState(() {
                        for (String pressed in widget.todoItem.todoList) {
                          if (pressed[index] == pressed[index]) {
                            widget.todoItem.isCrossed =
                                !widget.todoItem.isCrossed;
                          }
                        }
                      });
                    },
                    activeColor: Colors.green,
                    checkColor: Colors.white,
                  ),
                  title: Text(widget.todoItem.todoList[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
