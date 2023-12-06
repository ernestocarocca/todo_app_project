import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class EditTodoPage extends StatefulWidget {
  const EditTodoPage({super.key});

  @override
  EditTodoPageState createState() => EditTodoPageState();
}

class EditTodoPageState extends State<EditTodoPage> {

   TodosManager todoManager = TodosManager();
    List<TodoItem> todoList = [];
  

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
                      decoration: todoList[index].isCrossed
                          ? TextDecoration.lineThrough
                          : null,
                    ),
                  ),
                ),
                subtitle: GestureDetector(
                  onTap: () {
                    _editTodo(index, isTitle: false);
                  },
                  child: Text(
                    todoList[index].title,
                    style: TextStyle(
                      decoration: todoList[index].isCrossed
                          ? TextDecoration.lineThrough
                          : null,
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
                    const SizedBox(width: 8.0),
                    GestureDetector(
                      onTap: () {
                        _confirmDelete(index);
                      },
                      child: const Icon(
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
    String currentValue =
        isTitle ? todoList[index].title : todoList[index].title;
    TextEditingController textController =
        TextEditingController(text: currentValue);
// Ernesto catch if String value is not empty (null)
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
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(textController.text);
              },
              child: const Text('Save'),
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
          todoList[index].title = newValue;
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
          title: const Text('Confirm Delete'),
          content: const Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != null ) {
      setState(() {
        todoList.removeAt(index);
      });
    }
  }
}
