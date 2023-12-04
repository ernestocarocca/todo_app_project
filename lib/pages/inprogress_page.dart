import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app_project/mobile_storage/shared_pref.dart';
import 'package:todo_app_project/pages/todomodel_page.dart';

class InProgressPage extends StatefulWidget {
  const InProgressPage({Key? key}) : super(key: key);

  @override
  _InProgressPageState createState() => _InProgressPageState();
}

class _InProgressPageState extends State<InProgressPage> {
  TodosManager todoManager = TodosManager();
  List<TodoItem> _savedTodoItemsInProgres = [];

  @override
  void initState() {
    super.initState();
    loadTodos();
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        title: const Text('In Progress Page'),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.orange,
              Color.fromARGB(255, 103, 62, 9)
            ], // Customize your gradient colors
          ),
        ),
        child: ListView.builder(
          itemCount: _savedTodoItemsInProgres.length,
          itemBuilder: (context, index) {
            var inProgressTodo = _savedTodoItemsInProgres[index];
            return Card(
              color: Colors.white70, // Customize your card color
              elevation: 5.0,
              margin: const EdgeInsets.symmetric(vertical: 8.0),
              child: ListTile(
                title: Text(
                  inProgressTodo.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
                subtitle: Text(
                  inProgressTodo.title,
                  style: const TextStyle(fontSize: 14.0),
                ),
                /*   onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (BuildContext context) => EditTodoPage(),
                    ),
                  );
                },*/
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
          if (isDoneList.contains(true)) {
            todosToShow.add(todo);
          }
        }
        setState(() {
          _savedTodoItemsInProgres = List.from(todosToShow);
          todosToShow.clear();
        });
      });
    } catch (e) {
      print('Error loading todos: $e');
    }
  }
}
