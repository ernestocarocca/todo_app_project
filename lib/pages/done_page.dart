import 'package:flutter/material.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/edittodo_page.dart';
import 'package:todo_app_project/pages/show_one_done_page.dart';

class DonePage extends StatefulWidget {
  @override
  _DonePageState createState() => _DonePageState();
}

class _DonePageState extends State<DonePage> {
  TodosManager todoManager = TodosManager();
  List<TodoItem> _savedTodoItemsInDone = [];

  @override
  void initState() {
    super.initState();
    loadTodos(); // Ernesto: Load tasks from SharedPreferences when the page initializes.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Done Page'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.green, Color.fromARGB(255, 13, 82, 13)],
          ),
        ),
        child: ListView.builder(
          itemCount: _savedTodoItemsInDone.length,
          itemBuilder: (context, index) {
            var doneTodoIndex = _savedTodoItemsInDone[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => ShowOneDoneTodoPage(
                      todoItem: doneTodoIndex,
                    ),
                  ),
                );
              },
              child: Card(
                color: Colors.white70, // Customize card color
                elevation: 5.0,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                child: ListTile(
                  title: Text(
                    doneTodoIndex.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  subtitle: Text(
                    doneTodoIndex.title,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void loadTodos() async {
    try {
      List<TodoItem> loadedTodos = await todoManager.getTodos();
      print(loadedTodos);
      List<TodoItem> todosToShow = [];
      setState(() {
        for (TodoItem todo in loadedTodos) {
          List<TodoTask> tasks = todo.todoList;
          List<bool> isDoneList = tasks.map((task) => task.isDone).toList();
          if (!isDoneList.contains(false)) {
            todosToShow.add(todo);
          }
        }
        setState(() {
          _savedTodoItemsInDone = List.from(todosToShow);
          todosToShow.clear();
        });
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }
}
