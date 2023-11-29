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
  TodosManager todoManager = TodosManager();

  List<TodoItem> _savedTodoItems = [];

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  List<TodoItem> todoList = [];
  List<String> newTodoDescriptions = [];
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
              addDescription();
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
                addNewItem();
                saveTodoItem();
                _loadTodos();
                //_saveTodos(_savedTodoItems);
              },
              child: const Text('Add Todo'),
            ),
            const SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: _savedTodoItems.length,
                itemBuilder: (context, index) {
                  final currentTodo = _savedTodoItems[index];
                  return Dismissible(
                    key: Key(currentTodo.title),
                    onDismissed: (direction) {
                      setState(() {
                        _savedTodoItems.removeAt(index);
                        _removeTodos(currentTodo);
                        print(_savedTodoItems.length);
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
                        subtitle:
                            Text(_savedTodoItems[index].todoList.toString()),
                        trailing: GestureDetector(
                          onTap: () {
                            _toggleTodo(index);
                          },
                          child: Icon(
                            _savedTodoItems[index].isCrossed
                                ? Icons.check_box
                                : Icons.check_box_outline_blank,
                            color: _savedTodoItems[index].isCrossed
                                ? Colors.green
                                : null,
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
/*
  Future<void> _addItemToList() async {
    String newItem = titleController.text.trim();
    if (newItem.isNotEmpty) {
      setState(() {
        _savedTodoItems.last.todoList.add(newItem);
      });

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> encodedItems =
          _savedTodoItems.map((item) => json.encode(item.toJson())).toList();
      prefs.setStringList('todoListKey', encodedItems);

      descriptionController.clear();
    }
  }
*/
  // Ernesto sets todoList items to the saved todoItems in shareprefs

  /*
  void _loadTodos() async {
    List<TodoItem> loadedTodos = await todoManager.getTodos();

    setState(() {
  _savedTodoItems = loadedTodos;

    });
  }
*/
  void _loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      setState(() {
        _savedTodoItems = loadedTodos;
        print(_savedTodoItems.length);
        debugPrint('load $_savedTodoItems');
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  void _removeTodos(TodoItem todo) async {
    await todoManager.removeTodos(todo);
    _loadTodos();
  }

  Future<void> addNewItem() async {
    String newTodoItem = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (newTodoItem.isNotEmpty) {
      List<String> todoDescriptions =
          description.isNotEmpty ? description.split(",") : [];

      TodoItem newItem =
          TodoItem(newTodoItem, todoDescriptions, false, description);

      _savedTodoItems.add(newItem);

      await _saveTodos(_savedTodoItems);

      titleController.clear();
      descriptionController.clear();
    }
    for (dynamic p in _savedTodoItems) {
      print(p);
      debugPrint(p.toString());
    }
  }

  void addDescription() {
    String newDescription = descriptionController.text.trim();
    if (newDescription.isNotEmpty) {
      setState(() {
        newTodoDescriptions.add(newDescription);
        descriptionController.clear();
      });
    }
  }

  void saveTodoItem() async {
    String newTodoItem = titleController.text.trim();
    if (newTodoItem.isNotEmpty && newTodoDescriptions.isNotEmpty) {
      TodoItem newItem = TodoItem(newTodoItem, newTodoDescriptions, false,
          ''); // Använd newTodoDescriptions
      _savedTodoItems.add(newItem);

      // Spara den uppdaterade listan av todo-items
      await _saveTodos(_savedTodoItems);

      // Rensa input-fält och beskrivningslistan
      setState(() {
        newTodoDescriptions.clear();
      });
    }
  }

  Future<void> _saveTodos(List<TodoItem> todoItems) async {
    // Save the list of todo items using your TodosManager or preferred method
    await todoManager.addTodoList(todoItems);
  }

  void _toggleTodo(int index) {
    setState(() {
      _savedTodoItems[index].isCrossed = !_savedTodoItems[index].isCrossed;
    });
  }
}
  /*

  Future<void> _addNewItem() async {
    String newTodoItem = titleController.text.trim();
    String description =  descriptionController.text.trim();
if(newTodoItem.isNotEmpty){
  setState(() {
    _savedTodoItems.last.todoList.add(newTodoItem);
  });

   


       

   
 

    List<String> todoList = description.isNotEmpty ? description.split(",") : [];

    TodoItem newItem = TodoItem(newTodoItem, todoList, false, description);
    setState(() {
      _savedTodoItems.add(newItem);
    });
List<String> enocode = 
  _savedTodoItems.map((item) => json.encode(item.toJson())).toList();

  todoManager.addTodoList(enocode.cast<TodoItem>());

    // Clear text fields after adding the new item
    titleController.clear();
    descriptionController.clear();
  }
*//*
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
*/

