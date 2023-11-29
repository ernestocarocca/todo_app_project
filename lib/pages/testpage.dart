import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';

class TodoListWidget extends StatefulWidget {
  @override
  _TodoListWidgetState createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  TodosManager todoManager = TodosManager();
  List<TodoItem> _savedTodoItems = [];
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeManager();
  }

  Future<void> _initializeManager() async {
    try {
      await TodosManager.init();
      await _loadTodos();
    } catch (e) {
      print('Error initializing manager: $e');
    }
  }

  Future<void> _loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      setState(() {
        _savedTodoItems = loadedTodos;
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  Future<void> addNewItem() async {
    try {
      String newTodoItem = titleController.text.trim();
      String description = descriptionController.text.trim();

      if (newTodoItem.isNotEmpty) {
        List<String> todoDescriptions =
            description.isNotEmpty ? description.split(" ") : [];

        TodoItem newItem =
            TodoItem(newTodoItem, todoDescriptions, false, description);

        setState(() {
          _savedTodoItems.add(newItem);
        });

        await _saveTodos(_savedTodoItems);

        titleController.clear();
        descriptionController.clear();
      }

      for (dynamic p in _savedTodoItems) {
        print(p);
        debugPrint(p.toString());
      }
    } catch (e) {
      print('Error adding new item: $e');
    }
  }

  Future<void> _saveTodos(List<TodoItem> todoItems) async {
    try {
      await todoManager.addTodoList(todoItems);
    } catch (e) {
      print('Error saving todos: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo List'),
      ),
      body: ListView.builder(
        itemCount: _savedTodoItems.length,
        itemBuilder: (context, index) {
          final currentTodo = _savedTodoItems[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              elevation: 4.0,
              child: ListTile(
                title: Text(
                  currentTodo.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(
                  currentTodo.todoList.toString(),
                ),
                trailing: Checkbox(
                  value: currentTodo.isCrossed,
                  onChanged: (value) {
                    setState(() {
                      currentTodo.isCrossed = value ?? false;
                    });
                    // Update logic for the todo item here
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
