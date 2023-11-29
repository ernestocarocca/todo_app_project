import 'package:flutter/material.dart';

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
              _loadTodos();
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
                  return Card(
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
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      debugPrint(loadedTodos.toString());
      setState(() {
        _savedTodoItems = loadedTodos;
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  void removeTodos(List<TodoItem> todo) async {
    await todoManager.removeTodos(todo);
    _loadTodos();
  }
/*
  Future<void> addNewItem() async {
    String newTodoItem = titleController.text.trim();
    String description = descriptionController.text.trim();
    if (newTodoItem.isNotEmpty) {
      List<String> todoDescriptions =
          description.isNotEmpty ? description.split(" ") : [];
      TodoItem newItem =
          TodoItem(newTodoItem, todoDescriptions, false, description);
      _savedTodoItems.add(newItem);
      await _saveTodos(_savedTodoItems);
      titleController.clear();
      descriptionController.clear();
    }
    for (dynamic p in _savedTodoItems) {
      debugPrint(p.toString());
    }
  }*/

  Future<void> addNewItem() async {
    String newTodoItem = titleController.text.trim();
    String description = descriptionController.text.trim();

    if (newTodoItem.isNotEmpty) {
      //List<String> todoDescriptions =
      //   description.isNotEmpty ? description.split(" ") : [];
      // TodoItem newItem = TodoItem('', [], false, description);
      //   _savedTodoItems.add(newItem);
      await _saveTodos(_savedTodoItems);
      titleController.clear();
      descriptionController.clear();
    }

    for (dynamic p in _savedTodoItems) {
      debugPrint(p.toString());
    }
  }

  void addDescription() {
    String newDescription = descriptionController.text.trim();
    if (newDescription.isNotEmpty) {
      setState(() {
        newTodoDescriptions.add(newDescription);
        _savedTodoItems.forEach((e) {
          newTodoDescriptions.addAll(e.todoList);
        });
        descriptionController.clear();
      });
    }
  }

  /*

  void addDescription() {
    String newDescription = descriptionController.text.trim();
    if (newDescription.isNotEmpty) {
      setState(() {
        newTodoDescriptions.add(newDescription);
        _savedTodoItems.map((e) => {newTodoDescriptions = e.todoList});
        descriptionController.clear();
      });
    }
  }  */

  void saveTodoItem() async {
    String newTodoItem = titleController.text.trim();
    if (newTodoDescriptions.isNotEmpty) {
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
    await todoManager.addTodoList(todoItems);
  }

  void _toggleTodo(int index) {
    setState(() {
      _savedTodoItems[index].isCrossed = !_savedTodoItems[index].isCrossed;
    });
  }
}
