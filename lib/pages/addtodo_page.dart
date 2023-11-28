import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';

//Ernesto: moved TodoItem class to Shae_pref file

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  _AddTodoPageState createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final TodosManager todoManager = TodosManager();
   List<TodoItem> _savedTodoItems = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TodoItem> todoList = [];
  List<TodoItem> _todoItems = [];

  @override
  void initState() {
    super.initState();
    _loadTodos(); // Ernesto: Load tasks from SharedPreferences when the page initializes.
    print('loaded in init');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Todo Page'),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              // Rensa listan när delete-ikonen trycks
              todoList.clear();
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('Title:'),
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                hintText: 'Enter title',
              ),
            ),
            const SizedBox(height: 16.0),
            const Text('Description:'),
            TextField(
              controller: descriptionController,
              decoration: const InputDecoration(
                hintText: 'Enter description',
              ),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                _addTodo();

                print(todoList.length);
                print(todoList.indexed);
              },
              child: const Text('Add Todo'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _todoItems.length,
                itemBuilder: (context, index) {
                  final currentTodo = todoList[index];
                  return Dismissible(
                    key: Key(currentTodo.title),
                    onDismissed: (direction) {
                      setState(() {
                        todoList.removeAt(index);
                        _removeTodos(currentTodo);
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("$currentTodo Deleted")));
                    },
                    background: Container(
                      color: Colors.red,
                      child: const Center(
                          child: Text(
                        "Deleted",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      )),
                    ),
                    child: Card(
                      child: ListTile(
                        title: Text(_savedTodoItems[index].title),
                        subtitle: Text(_savedTodoItems[index].description),
                        trailing: GestureDetector(
                          onTap: () {
                            _toggleTodo(index);
                          },
                          child: Icon(
                            todoList[index].isCrossed
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color:
                                todoList[index].isCrossed ? Colors.green : null,
                          ),
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

Future<void> _addItemToList() async {
    String newItem = titleController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        _savedTodoItems.last.todoList.add(newItem);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> encodedItems = _savedTodoItems.map((item) => json.encode(item.toJson())).toList();
      prefs.setStringList('todoListKey', encodedItems);

      descriptionController.clear();
    }
  }
 Future<void> _addNewItem() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();
 

    List<String> todoList = description.isNotEmpty ? description.split(",") : [];

    TodoItem newItem = TodoItem(title, todoList, false, description);

    setState(() {
      _savedTodoItems.add(newItem);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedItems = _savedTodoItems.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('todoListKey', encodedItems);

    // Clear text fields after adding the new item
    titleController.clear();
    descriptionController.clear();
   
  }
  // Ernesto sets todoList items to the saved todoItems in shareprefs
  void _loadTodos() async {
    List<TodoItem> todos = await TodosManager().getTodos();
    final loadedTodos = await todoManager.getTodos();

    setState(() {
      _todoItems = todos;
      todoList = loadedTodos;
    });
  }

  void _removeTodos(TodoItem todo) async {
    await todoManager.removeTodos(todo);
    _loadTodos();
  }

  void _addTodo() async {
    String title = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (title.isNotEmpty && description.isNotEmpty) {
      setState(() {
        List<String> todoList = [];
        bool isCrossed = false;
        List<TodoItem> todo = [
          TodoItem(title, todoList, isCrossed, description)
        ];
        todoManager.addTodoList(todo);

        titleController.clear();
        descriptionController.clear();
        _loadTodos();
      });
    }
  }

  void _toggleTodo(int index) {
    setState(() {
      todoList[index].isCrossed = !todoList[index].isCrossed;
    });
  }
}
