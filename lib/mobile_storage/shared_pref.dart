// ignore_for_file: unused_element

import 'dart:convert';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';




class TodoItem {
  final String title;
  List<String> todoList; // Listan av uppgifter
  bool isCrossed;
  final String description;
  TodoItem(
    this.title,
    this.todoList,
    this.isCrossed,
    this.description,
  );
  Map<String, Object> toJson() {
    return {
      'title': title,
      'todoList': todoList,
      'isCrossed': isCrossed,
      'description': description,
    };
  }

  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      map['title'],
      List<String>.from(map[
          'todoList']), // Konvertera listan från dynamisk till en lista av strängar
      map['isCrossed'],
      map['description'],
    );
  }
}

class TodosManager {
  static late SharedPreferences _prefs;
  static const _keyTodo = 'Todo';

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    print('SharedPreferences initialiserades');
  }
Future<void> addTodoList(List<TodoItem> todoList) async {
  final List<String> todos = _prefs.getStringList(_keyTodo) ?? [];

  for (TodoItem todo in todoList) {
    todos.add(json.encode(todo.toJson()));
  }

  await _prefs.setStringList(_keyTodo, todos);
}



 /*
    final List<String> todos =
        todoList.map((todo) => json.encode(todo.toJson())).toList();
    await _prefs.setStringList(_keyTodo, todos);
  } */

  Future<void> removeTodos(TodoItem todo) async {
    final List<String> todos = _prefs.getStringList(_keyTodo) ?? [];

    todos.removeWhere((taskJson) {
      final todoData = json.decode(taskJson);
      return todoData['title'] == todo.title &&
          todoData['isCrossed'] == todo.isCrossed &&
          todoData['description'] == todo.description;
    });

    await _prefs.setStringList(_keyTodo, todos);
  }
Future<List<TodoItem>> getTodos() async {
  final List<String> todos = _prefs.getStringList(_keyTodo) ?? [];
  List<TodoItem> todoItems = [];

  for (String todoJson in todos) {
    try {
      final Map<String, dynamic> todoData = json.decode(todoJson);

      // Kolla om strukturen är för det nya TodoItem-formatet med en lista av uppgifter
      if (todoData.containsKey('title') &&
          todoData.containsKey('todoList') &&
          todoData.containsKey('isCrossed') &&
          todoData.containsKey('description')) {
        final TodoItem todoItem = TodoItem.fromMap(todoData);
        todoItems.add(todoItem);
      }
    } catch (e) {
      print('Fel vid avkodning av TodoItem: $e');
    }
  }

  return todoItems;
}
}


/*
class SharedPreferencesManager {
  static late SharedPreferences _preferences;
  static const _keyInputName = 'inputesName';
  static const _keysTodos = 'todos';
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static SharedPreferences get preferences {
    return _preferences;
  }

  static Future setNames(String names) async =>
      await _preferences.setString(_keyInputName, names);
  static getNames() => _preferences.getString(_keyInputName);

  static Future setTodos(List<String> todoList) async =>
      await _preferences.setStringList(_keysTodos, todoList);
  static List<String>? getTodos() => _preferences.getStringList(_keysTodos);
}
*/
// ignore_for_file: public_member_api_docs, sort_constructors_first





  /*
  @override
  void initState() {
    super.initState();
    _loadTasks();
  }*/


/*
  void _loadTasks() async {
    final loadedTasks = await taskManager.getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }*/
/*
  Widget buildTextField() {
    return Row(
      children: [
        TextField(
          controller: taskController,
          decoration: const InputDecoration(
            hintText: 'add Todo......',

            // Other decoration properties if needed
          ),
        ),
      
      ],
    );
  }*/



 /*

  @override
  Widget build(BuildContext context)  => addTodoWidget{
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 32),
          buildName(),
          // buildTextField(),
          const SizedBox(height: 32),
          buildButtonSharePrev(),
          SizedBox(height: 32),
          Container(
            width: 200.0,
            height: 200.0,
            color: Colors
                .blue, // Lägg till färg eller annan egenskap för att visa containern
            child:
                addTodoWidget(), // Se till att addTodoWidget returnerar en widget med en fast storlek
          ),
        ],
      ),
    );
  } */
  /*

  Widget addTodoWidget() {

    requare 
    return Scaffold(
      appBar: AppBar(
        title: Text('Task List'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                      labelText: 'New Task',
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: _addTask,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return ListTile(
                  title: Text(task.title),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () => _removeTask(task),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  } */
/*
// textfield that takes in a value and sets it for saving in Shpref uses BuildTitelWigget
  Widget buildName() => buildTitle(
        title: 'add tour todo',
        child: TextFormField(
          initialValue: todo,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            hintText: 'Add....',
          ),
          onChanged: (todo) => setState(() => this.todo = todo),
        ),
      );

// Ernesto: add todos in a list
  Widget buildButtonSharePrev() =>
      ButtonWidget(text: 'save', onClicked: () async {});

  Widget buildTitle({
    required String title,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 8),
          child,
        ],
      );
}
/*
class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    Key? key,
    required this.text,
    required this.onClicked,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            minimumSize: Size.fromHeight(52),
            backgroundColor: Colors.black,
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(25),
            ),
          ),
          onPressed: onClicked,
          child: Text(
            text,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
      );
} */



*/

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SharedPreferences Demo',
      home: SavedDataScreen(),
    );
  }
}

class SavedDataScreen extends StatefulWidget {
  @override
  _SavedDataScreenState createState() => _SavedDataScreenState();
}

class _SavedDataScreenState extends State<SavedDataScreen> {
  List<TodoItem> _savedTodoItems = [];
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();
  TextEditingController _todoListController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadSavedData();
  }

  Future<void> _loadSavedData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> savedData = prefs.getStringList('todoListKey') ?? [];

    setState(() {
      _savedTodoItems = savedData
          .map((item) => TodoItem.fromMap(json.decode(item)))
          .toList();
    });
  }

  Future<void> _addNewItem() async {
    String title = _titleController.text.trim();
    String description = _descriptionController.text.trim();
    String todoListText = _todoListController.text.trim();

    List<String> todoList = todoListText.isNotEmpty ? todoListText.split(",") : [];

    TodoItem newItem = TodoItem(title, todoList, false, description);

    setState(() {
      _savedTodoItems.add(newItem);
    });

    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedItems = _savedTodoItems.map((item) => json.encode(item.toJson())).toList();
    prefs.setStringList('todoListKey', encodedItems);

    // Clear text fields after adding the new item
    _titleController.clear();
    _descriptionController.clear();
    _todoListController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Saved Data'),
      ),
      body: ListView.builder(
        itemCount: _savedTodoItems.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(_savedTodoItems[index].title),
            subtitle: Text(_savedTodoItems[index].description),
            trailing: Text(_savedTodoItems[index].todoList.join(", ")),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text('Add New Item'),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titleController,
                      decoration: InputDecoration(labelText: 'Title'),
                    ),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(labelText: 'Description'),
                    ),
                    TextField(
                      controller: _todoListController,
                      decoration: InputDecoration(labelText: 'Todo List (Separate by comma)'),
                    ),
                  ],
                ),
                actions: [
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      _addNewItem();
                    },
                    child: Text('Save'),
                  ),
                ],
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}