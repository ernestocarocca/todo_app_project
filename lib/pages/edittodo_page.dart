import 'package:flutter/material.dart';


void main() {
  runApp(MyApp());
}

class TodoItem {
  bool isCrossed;
  String title;
  String description;

  TodoItem({required this.isCrossed, required this.title, required this.description});
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: EditTodoPage(),
    );
  }
}

class EditTodoPage extends StatefulWidget {
  @override
  _EditTodoPageState createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  List<TodoItem> todoList = [
    TodoItem(isCrossed: false, title: 'Task 1', description: 'Description 1'),
    TodoItem(isCrossed: false, title: 'Task 2', description: 'Description 2'),
    TodoItem(isCrossed: false, title: 'Task 3', description: 'Description 3'),
  ];


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text('Edit Todo Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: todoList.length,
          itemBuilder: (context, index) {
            return Card(
              child: ListTile(
                title: GestureDetector(
                  onTap: () {
                    _editTodo(index, isTitle: true);
                  },
                  child: Text(
                    todoList[index].title,
                    style: TextStyle(
                      decoration: todoList[index].isCrossed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                subtitle: GestureDetector(
                  onTap: () {
                    _editTodo(index, isTitle: false);
                  },
                  child: Text(
                    todoList[index].description,
                    style: TextStyle(
                      decoration: todoList[index].isCrossed ? TextDecoration.lineThrough : null,
                    ),
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                      onTap: () {
                        _toggleTodo(index);
                      },
                      child: Icon(
                        todoList[index].isCrossed
                            ? Icons.check_box
                            : Icons.check_box_outline_blank,
                        color: todoList[index].isCrossed ? Colors.green : null,
                      ),
                    ),
                    SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        _confirmDelete(index);
                      },
                      child: Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _editTodo(int index, {required bool isTitle}) async {
    String currentValue = isTitle ? todoList[index].title : todoList[index].description;
    TextEditingController textController = TextEditingController(text: currentValue);

    String newValue = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(isTitle ? 'Edit Title' : 'Edit Description'),
          content: TextField(
            controller: textController,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textController.text);
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );

    if (newValue != null && newValue.isNotEmpty) {
      setState(() {
        if (isTitle) {
          todoList[index].title = newValue;
        } else {
          todoList[index].description = newValue;
        }
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todoList[index].isCrossed = !todoList[index].isCrossed;
    });
  }

  void _confirmDelete(int index) async {
    bool shouldDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Delete'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != null && shouldDelete) {
      setState(() {
        todoList.removeAt(index);
      });
    }
  }
}

