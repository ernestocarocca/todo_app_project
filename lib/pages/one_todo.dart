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
  List<bool> taskCompletionStatus = [];

  @override
  void initState() {
    super.initState();
    // Initialize the list with the completion status of each task
    taskCompletionStatus =
        List.generate(widget.todoItem.todoList.length, (index) => false);
  }

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
                    value: taskCompletionStatus[index],
                    onChanged: (value) {
                      setState(() {
                        // Toggle the completion status of the task
                        taskCompletionStatus[index] = value!;
                        // Handle your logic for overall task completion here
                        widget.todoItem.isCrossed =
                            taskCompletionStatus.contains(true);
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