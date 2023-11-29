import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class ToDoDetailsPage extends StatelessWidget {
  final TodoItem todoItem;


  const ToDoDetailsPage({Key? key, required this.todoItem}) : super(key: key);

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
              'Title: ${todoItem.title}',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8.0),
            Text('Description: ${todoItem.description}'),
            SizedBox(height: 8.0),
            Text(
              'Status: ${todoItem.isCrossed ? 'Completed' : 'Incomplete'}',
              style: TextStyle(
                  color: todoItem.isCrossed ? Colors.green : Colors.red),
            ),
            SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              itemCount: todoItem.todoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  leading: Checkbox(
                    value: todoItem.isCrossed,
                    onChanged: (value) {
                      // Implement checkbox functionality here
                      // You may want to update the 'isCompleted' status for the specific todo
                    },
                  ),
                title: Text(todoItem.todoList[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
