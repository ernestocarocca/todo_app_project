// ignore_for_file: unused_element
import 'package:flutter/material.dart';
//import 'package:shared_preferences/shared_preferences.dart';

import 'package:todo_app_project/mobile_storage/shared_pref.dart';

import 'dart:convert';
import 'dart:core';

import 'package:shared_preferences/shared_preferences.dart';

class Task {
  final String title;
  final bool isCompleted;

  Task(this.title, this.isCompleted);

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }
}

class TaskManager {
  static const _key = 'tasks';

  Future<void> addTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tasks = prefs.getStringList(_key) ?? [];

    tasks.add(json.encode(task.toJson()));

    await prefs.setStringList(_key, tasks);
  }

  Future<void> removeTask(Task task) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tasks = prefs.getStringList(_key) ?? [];

    tasks.removeWhere((taskJson) {
      final taskData = json.decode(taskJson);
      return taskData['title'] == task.title &&
          taskData['isCompleted'] == task.isCompleted;
    });

    await prefs.setStringList(_key, tasks);
  }

  Future<List<Task>> getTasks() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> tasks = prefs.getStringList(_key) ?? [];

    return tasks.map((taskJson) {
      final taskData = json.decode(taskJson);
      return Task(taskData['title'], taskData['isCompleted']);
    }).toList();
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

class SharePrefAddTodoPage extends StatefulWidget {
  const SharePrefAddTodoPage({Key? key}) : super(key: key);

  @override
  _SharePrefAddTodoPageState createState() => _SharePrefAddTodoPageState();
}

class _SharePrefAddTodoPageState extends State<SharePrefAddTodoPage> {
  final TaskManager taskManager = TaskManager();
  final TextEditingController taskController = TextEditingController();
  List<Task> tasks = [];

  late final String label;
  String todo = '';
  @override
  void initState() {
    super.initState();
    _loadTasks();
    // textEditingController = TextEditingController();

//    _getTodoList = SharedPreferencesManager.getTodos() ??
    // []; // Ernesto: init when page renders
  }

  void _addTask() async {
    final taskTitle = taskController.text;
    if (taskTitle.isNotEmpty) {
      final task = Task(taskTitle, false);
      await taskManager.addTask(task);
      taskController.clear();
      _loadTasks();
    }
  }

  void _loadTasks() async {
    final loadedTasks = await taskManager.getTasks();
    setState(() {
      tasks = loadedTasks;
    });
  }
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

  // void setTodoText() {}
  void _removeTask(Task task) async {
    await taskManager.removeTask(task);
    _loadTasks();
  }

  @override
  void dispose() {
    //  textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
  }

  Widget addTodoWidget() {
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
  }

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
}



/*




class AddTodoPage extends StatelessWidget {
  const AddTodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Add ToDo Page'),);
  }
}
*/
