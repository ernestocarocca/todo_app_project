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
      home: const AddTodoPage(),
    );
  }
}

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TodoItem> todoList = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Page'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Title:'),
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Enter title',
              ),
            ),
            SizedBox(height: 16.0),
            Text('Description:'),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                hintText: 'Enter description',
              ),
            ),
            SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addTodo();
              },
              child: Text('Add Todo'),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: todoList.length,
                itemBuilder: (context, index) {
                  return Card(
                    child: ListTile(
                      title: Text(todoList[index].title),
                      subtitle: Text(todoList[index].description),
                      trailing: GestureDetector(
                        onTap: () {
                          _toggleTodo(index);
                        },
                        child: Icon(
                          todoList[index].isCrossed ? Icons.check_box : Icons.check_box_outline_blank,
                          color: todoList[index].isCrossed ? Colors.green : null,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _addTodo() {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        todoList.add(TodoItem(isCrossed: false, title: title, description: description));
        titleController.clear();
        descriptionController.clear();
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todoList[index].isCrossed = !todoList[index].isCrossed;
    });
  }
}
